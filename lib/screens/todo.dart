import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../colors.dart';
import '../group_by.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);

  @override
  _TodoPage createState() => _TodoPage();
}

class _TodoPage extends State<TodoPage> {
  final _firestore = FirebaseFirestore.instance;

  Map<String, String> _user;
  Map<DateTime, dynamic> _events;

  CalendarController _calendarController;

  DateTime _selectedDay = DateTime.now();
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _user = context.read<AuthenticationService>().userData;

    _firestore
        .collection('todos')
        .where('userId', isEqualTo: _user['id'])
        .snapshots()
        .listen((event) {
      setState(() {
        final formattedTodos = event.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc.data()['title'],
            'description': doc.data()['description'],
            'completed': doc.data()['completed'],
            'timestamp': DateTime.fromMillisecondsSinceEpoch(
                doc.data()['timestamp'].seconds * 1000),
          };
        });

        final groupedEvents = formattedTodos.groupBy((m) => m['timestamp']);
        _events = groupedEvents.cast<DateTime, List<dynamic>>();
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? PrimaryColors.pink
            : _calendarController.isToday(date)
                ? Colors.pink[200]
                : PrimaryColors.pink,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  void dayChanged(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;

      print(_selectedEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthenticationService>().userData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          userData['displayName'],
          style: TextStyle(
              color: PrimaryColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await context.read<AuthenticationService>().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (_) => Colors.transparent)),
              child: Icon(
                Icons.logout,
                color: PrimaryColors.black,
              )),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            TableCalendar(
              events: _events,
              calendarController: _calendarController,
              onDaySelected: (day, events, holidays) => dayChanged(day, events),
              initialCalendarFormat: CalendarFormat.month,
              availableCalendarFormats: {CalendarFormat.month: 'month'},
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.w600),
                weekendStyle:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              ),
              calendarStyle: CalendarStyle(
                selectedColor: PrimaryColors.pink,
                todayColor: Colors.pink[200],
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  color: PrimaryColors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: PrimaryColors.pink,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: PrimaryColors.pink,
                ),
              ),
              builders: CalendarBuilders(
                markersBuilder: (context, date, events, _) {
                  final children = <Widget>[];

                  if (events.isNotEmpty) {
                    children.add(
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: _buildEventsMarker(date, events),
                      ),
                    );
                  }

                  return children;
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: PrimaryColors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _calendarController.isToday(_selectedDay)
                              ? 'Today'
                              : '${_selectedDay.day}.${_selectedDay.month}.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: PrimaryColors.pink,
      ),
    );
  }
}

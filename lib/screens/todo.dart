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
  Map<DateTime, List<dynamic>> _events;

  CalendarController _calendarController;

  final now = DateTime.now();
  DateTime _selectedDay;

  List<dynamic> _selectedEvents = [];

  DateTime _addTodoDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _user = context.read<AuthenticationService>().userData;

    _selectedDay = new DateTime(now.year, now.month, now.day);

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
            'timestamp': doc.data()['timestamp'],
          };
        });

        final groupedEvents = formattedTodos.groupBy((m) =>
            DateTime.fromMillisecondsSinceEpoch(
                (m['timestamp'].seconds * 1000)));
        _events = groupedEvents.cast<DateTime, List<dynamic>>();

        print(_events);

        _selectedEvents = groupedEvents[_selectedDay].length > 0 &&
                _calendarController.isSelected(_selectedDay)
            ? groupedEvents[_selectedDay]
            : [];
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    final eventsInProgress = events.map((e) => e).toList();
    eventsInProgress.removeWhere((e) => e['completed']);

    if (eventsInProgress.length < 1) return Container();
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
          '${eventsInProgress.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildListViewItem(context, index) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
    );

    final currentEvent = _selectedEvents[index];
    bool completed = currentEvent['completed'];

    return Row(
      children: [
        IconButton(
            icon: completed
                ? Icon(Icons.check_circle, color: PrimaryColors.pink, size: 28)
                : Icon(Icons.radio_button_unchecked,
                    color: PrimaryColors.pink, size: 28),
            onPressed: () async {
              await _firestore.runTransaction((transaction) {
                transaction.update(
                    _firestore.collection('todos').doc(currentEvent['id']), {
                  'completed': !completed,
                });
              });
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedEvents[index]['title'],
                style: completed
                    ? textStyle.copyWith(
                        color: Colors.white70,
                        decoration: TextDecoration.lineThrough)
                    : textStyle,
              ),
              Text(
                _selectedEvents[index]['description'],
                style: completed
                    ? textStyle.copyWith(
                        color: Colors.white70,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12.0,
                      )
                    : textStyle.copyWith(
                        fontSize: 12.0,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void dayChanged(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedDay = new DateTime(day.year, day.month, day.day);
      print(events);
      _selectedEvents = events;
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PrimaryColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15.0,
                  ),
                  child: Text(
                    'Add todo',
                    style: TextStyle(color: PrimaryColors.pink, fontSize: 30.0),
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          autofocus: true,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Title',
                            contentPadding: EdgeInsets.only(
                                top: -10, bottom: -10, left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          // autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Description',
                            contentPadding: EdgeInsets.only(
                                top: -10, bottom: -10, left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDay = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 365)),
                                    lastDate: DateTime.now().add(
                                      Duration(days: 365),
                                    ));

                                setState(() => _addTodoDay = selectedDay != null
                                    ? selectedDay
                                    : DateTime.now());
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.resolveWith(
                                    (states) => 0),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (_) => Colors.transparent),
                                shape: MaterialStateProperty.resolveWith(
                                  (_) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                side: MaterialStateProperty.resolveWith(
                                  (_) => BorderSide(
                                    width: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Text(
                                  '${_addTodoDay.day}.${_addTodoDay.month}. ${_addTodoDay.year}'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: PrimaryColors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.add, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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
                child: Padding(
                  padding: EdgeInsets.only(top: 30, right: 30, left: 30),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _calendarController.isToday(_selectedDay)
                                ? 'Today'
                                : '${_selectedDay.day}.${_selectedDay.month}.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedEvents.length,
                            itemBuilder: (context, index) =>
                                _buildListViewItem(context, index),
                          ),
                        ),
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
        onPressed: () => _settingModalBottomSheet(context),
        child: Icon(Icons.add),
        backgroundColor: PrimaryColors.pink,
      ),
    );
  }
}

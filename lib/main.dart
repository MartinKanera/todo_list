import 'package:flutter/material.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColor.black,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TodoPage(),
        '/a': (BuildContext context) => TodoPage(),
      },
    );
  }
}

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);

  @override
  _TodoPage createState() => _TodoPage();
}

class _TodoPage extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

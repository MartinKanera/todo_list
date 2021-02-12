import 'package:flutter/material.dart';
import 'colors.dart';
import 'screens/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColors.black,
      ),
      home: RegisterPage(),
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

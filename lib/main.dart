import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/colors.dart';
import 'authentication_service.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'screens/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(),
          ),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.pink),
          routes: {
            '/': (context) => LoadingPage(),
            '/todo': (context) => TodoPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
          },
        ));
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> init() async {
    final user = context.read<AuthenticationService>().user;

    if (user != null) {
      context
          .read<AuthenticationService>()
          .loadUserData(userId: user.uid)
          .then((_) {
        Navigator.pushReplacementNamed(context, '/todo');
      });
      print(context.read<AuthenticationService>().userData);
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

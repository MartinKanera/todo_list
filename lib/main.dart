import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'screens/register.dart';
import 'screens/login.dart';

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
      await context.read<AuthenticationService>().loadUserData();
      Navigator.pushReplacementNamed(context, '/todo');
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/register');
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

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);

  @override
  _TodoPage createState() => _TodoPage();
}

class _TodoPage extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
            onPressed: () async {
              context.read<AuthenticationService>().signOut();
              Navigator.pushReplacementNamed(context, '/register');
            },
            child: Icon(
              Icons.logout,
            )),
      ),
    );
  }
}

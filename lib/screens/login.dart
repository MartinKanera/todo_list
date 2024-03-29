import 'package:flutter/material.dart';
import '../colors.dart';
import '../authentication_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email, password;

  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            width: double.infinity,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 80,
                margin: EdgeInsets.only(left: 40, right: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            onChanged: (text) => email = text,
                            validator: (value) {
                              RegExp emailReg = new RegExp(
                                  r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$",
                                  caseSensitive: false,
                                  multiLine: false);

                              if (value.isEmpty)
                                return 'Please enter your email';

                              if (!emailReg.hasMatch(value))
                                return 'Invalid email';

                              return null;
                            },
                            onEditingComplete: () => node.nextFocus(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              contentPadding: EdgeInsets.only(
                                  top: -10, bottom: -10, left: 10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            onChanged: (text) => password = text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }

                              return null;
                            },
                            onEditingComplete: () => node.nextFocus(),
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              contentPadding: EdgeInsets.only(
                                  top: -10, bottom: -10, left: 10),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  String error = await context
                                      .read<AuthenticationService>()
                                      .signIn(email: email, password: password);
                                  if (error.isEmpty)
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/todo', (r) => false);
                                  else
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error)));
                                }
                              },
                              child: Text('Login'),
                              textColor: Colors.white,
                              color: PrimaryColors.pink,
                              elevation: 5,
                              minWidth: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: MaterialButton(
                              onPressed: () async {
                                await context
                                    .read<AuthenticationService>()
                                    .signInWithGoogle();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/todo', (r) => false);
                              },
                              textColor: Colors.black,
                              color: Colors.white,
                              elevation: 5,
                              minWidth: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    child:
                                        Image.asset('assets/images/google.png'),
                                  ),
                                  Text('Signup with Google'),
                                  Container(
                                    width: 16,
                                  )
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/register'),
                                style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chevron_left,
                                      color: PrimaryColors.black,
                                    ),
                                    Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: PrimaryColors.black,
                                        color: PrimaryColors.black,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

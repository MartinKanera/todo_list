import 'package:flutter/material.dart';
import '../colors.dart';
import 'package:provider/provider.dart';
import '../authentication_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String firstName, lastName, email, password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
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
                              onChanged: (text) => firstName = text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your first name';
                                }

                                return null;
                              },
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'First name',
                                contentPadding: EdgeInsets.only(
                                    top: -10, bottom: -10, left: 10),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            onChanged: (text) => lastName = text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your last name';
                              }

                              return null;
                            },
                            onEditingComplete: () => node.nextFocus(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last name',
                              contentPadding: EdgeInsets.only(
                                  top: -10, bottom: -10, left: 10),
                            ),
                          ),
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
                                  await context
                                      .read<AuthenticationService>()
                                      .signUp(
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          password: password);
                                  Navigator.pushReplacementNamed(
                                      context, '/todo');
                                }
                              },
                              child: Text('Register'),
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
                                Navigator.pushReplacementNamed(
                                    context, '/todo');
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/login'),
                                style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: PrimaryColors.black,
                                        color: PrimaryColors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: PrimaryColors.black,
                                    ),
                                  ],
                                ))
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

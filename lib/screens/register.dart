import 'package:flutter/material.dart';
import '../colors.dart';
import '../authentication_service.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 80,
                margin: EdgeInsets.only(left: 40, right: 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First name',
                              contentPadding: EdgeInsets.only(
                                  top: -10, bottom: -10, left: 10),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last name',
                            contentPadding: EdgeInsets.only(
                                top: -10, bottom: -10, left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            contentPadding: EdgeInsets.only(
                                top: -10, bottom: -10, left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
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
                            onPressed: () => {print('Register')},
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
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: MaterialButton(
                            onPressed: () async => {
                              await AuthenticationService().signInWithGoogle()
                            },
                            textColor: Colors.black,
                            color: Colors.white,
                            elevation: 5,
                            minWidth: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    ],
                  ),
                ),
              ),
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:pick_and_go/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'file:///C:/Users/Saeed/AndroidStudioProjects/pick_and_go/lib/components/constant.dart';
import 'kiosks.dart';

import 'package:fluttertoast/fluttertoast.dart';

class login extends StatefulWidget {
  // naming this current page to easily route
  static const String id = 'login';
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  // declare variables
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        //ModalProgressHUD to show loading spinner
        // while check the email and password the the database
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  //hero widget to get the logo from thew previous page

                  tag: 'logo',
                  child: Container(
                    height: 400.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value.trim();
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value.trim();
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.brown,
                onPressed: () async {
                  //conditions to validate the login process
                  if (email == null) {
                    toast('Please enter a valid email');
                  }
                  if (password == null) {
                    toast('Please enter a valid password');
                  } //end of the conditions
                  else {
                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null) {
                        setState(() {
                          showSpinner = false;
                        });
                        // Navigator to kiosks page
                        toast("You Logged in successfully!! ");
                        Navigator.pushReplacementNamed(context, kiosks.id);
                      }
                      // _auth.fetchSignInMethodsForEmail(email: email);
                    } catch (SignInError) {
                      //catch if the email is malformed
                      if (SignInError.code == 'ERROR_INVALID_EMAIL') {
                        toast("you entered a malformed email,\n "
                            "please  try again");
                        setState(() {
                          showSpinner = false;
                        });
                      }
                      //catch if the email is not registered
                      if (SignInError.code == 'ERROR_USER_NOT_FOUND') {
                        toast("The email you entered is not registered,\n "
                            "please  try again");

                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //toast method to save some redundant code
  void toast(String valid) {
    Fluttertoast.showToast(
        msg: valid,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

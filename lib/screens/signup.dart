import 'package:flutter/material.dart';
import 'package:pick_and_go/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'file:///C:/Users/Saeed/AndroidStudioProjects/pick_and_go/lib/components/constant.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signup extends StatefulWidget {
  // naming this current page to easily route
  static const String id = 'signup';
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  //declare variables
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String name;
  String plate;
  //boolean method to validate password
  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
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
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your Name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  plate = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Licence Plate'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
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
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.brown[900],
                onPressed: () async {
                  //conditions to validate the registration process
                  if (email == null) {
                    toast('Please enter a valid email');
                  }
                  if (name == null || name.length < 3) {
                    toast('Please enter a valid name');
                  }
                  if (plate == null || plate.length < 3) {
                    toast('Please enter a valid plate');
                  }
                  if (password == null) {
                    toast('Please enter a valid password');
                  }
                  if (!validateStructure(password)) {
                    toast(
                      "Your Password must include:"
                      "\nMinimum 1 Upper case"
                      "\nMinimum 1 lowercase"
                      "\nMinimum 1 Numeric Number",
                    );
                  }

                  //end of the conditions
                  else {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      //create new user to the firebase
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        // Navigator
                        toast("You signed up successfully!! ");
                        Navigator.pushReplacementNamed(context, login.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (signUpError) {
                      //catch if the email already exists in firebase
                      if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                        toast("The email you entered is used,\n "
                            "please sign in or try a different email");
                        setState(() {
                          showSpinner = false;
                        });
                      }
                      //////////////////////
                      //catch if the email is malformed
                      if (signUpError.code == 'ERROR_INVALID_EMAIL') {
                        toast("you entered a malformed email,\n "
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

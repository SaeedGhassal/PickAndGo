import 'package:flutter/material.dart';
import 'package:pick_and_go/screens/login.dart';
import 'logoScreen.dart';
import 'signup.dart';

void main() {
  runApp(PickAndGo());
}

class PickAndGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: logoScreens.id,
      routes: {
        logoScreens.id: (context) => logoScreens(),
        signup.id: (context) => signup(),
        login.id: (context)=> login(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/logoScreen.dart';
import 'screens/signup.dart';

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
      },
    );
  }
}

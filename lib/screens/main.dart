import 'package:flutter/material.dart';
import 'package:pick_and_go/screens/login.dart';
import 'logoScreen.dart';
import 'signup.dart';
import 'kiosks.dart';
import 'maps.dart';
import 'selectOrders.dart';

void main() {
  runApp(PickAndGo());
}

class PickAndGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initializing the first page to occur
      initialRoute: logoScreens.id,

      // naming the routes to navigate the screens easily
      routes: {
        logoScreens.id: (context) => logoScreens(),
        signup.id: (context) => signup(),
        login.id: (context) => login(),
        kiosks.id: (context) => kiosks(),
        maps.id: (context) => maps(),
        selectOrders.id: (context) => selectOrders(),
      },
    );
  }
}

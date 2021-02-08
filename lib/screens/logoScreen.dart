import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pick_and_go/components/rounded_button.dart';
import 'signup.dart';
import 'login.dart';

class logoScreens extends StatefulWidget {
  static const String id = 'logo_screen';
  @override
  _logoScreensState createState() => _logoScreensState();
}

class _logoScreensState extends State<logoScreens>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 250.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Pick & Go'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.brown[500],
              onPressed: () {
                Navigator.pushNamed(context, login.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.brown[700],
              onPressed: () {
                Navigator.pushNamed(context, signup.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

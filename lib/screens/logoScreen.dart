import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pick_and_go/components/rounded_button.dart';
import 'signup.dart';
import 'login.dart';

class logoScreens extends StatefulWidget {
  // naming this current page to easily route
  static const String id = 'logo_screen';
  @override
  _logoScreensState createState() => _logoScreensState();
}

class _logoScreensState extends State<logoScreens>
    with SingleTickerProviderStateMixin {
  // declare public variables
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
                  //hero widget so they can transfer the logo to the next page
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 250.0,
                  ),
                ),
                TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  //TypewriterAnimatedTextKit to show the app name in a fancy way

                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  text: ['Pick & Go', 'Pick & Go', 'Pick & Go', 'Pick & Go'],
                  // the text duplicated 4 times then stops the animation
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
                //navigate to login page
                Navigator.pushNamed(context, login.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.brown[700],
              onPressed: () {
                //navigate to signup page
                Navigator.pushNamed(context, signup.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

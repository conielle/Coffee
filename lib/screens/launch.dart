import 'package:coffee/screens/chat_screen.dart';
import 'package:coffee/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coffee/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchScreen extends StatefulWidget {
  static const String id = 'launch_screen';

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  Future<void> initializeDefault() async {
    print('Nothing to see here');
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
    firstPageChecker();
  }



  void firstPageChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? false;
    if (isFirstLaunch ?? null) {Navigator.pushNamed(context, WelcomeScreen.id);} else if (isFirstLaunch == true){
      Navigator.pushNamed(context, WelcomeScreen.id);
    } else {Navigator.pushNamed(context, ChatScreen.id);}
  }




  @override
  void initState() {
    super.initState();
    setState(() {
      initializeDefault();
    });

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Color.fromRGBO(187, 222, 251, 1),)
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
    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: appConfigblockSizeHeight * 8,
                      ),
                    ),
                    TypewriterAnimatedTextKit(
                      text: ['Coffee.'],
                      textStyle: TextStyle(
                        fontSize: fontSize * 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),


                  ],
                ),
                SizedBox(height: appConfigblockSizeHeight * 2,),
                Text('Personal Edition', style: TextStyle(fontSize: fontSize * 7),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

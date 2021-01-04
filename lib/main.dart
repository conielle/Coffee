import 'package:coffee/screens/launch.dart';
import 'package:coffee/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:coffee/screens/welcome_screen.dart';
import 'package:coffee/screens/login_screen.dart';
import 'package:coffee/screens/registration_screen.dart';
import 'package:coffee/screens/chat_screen.dart';
import 'package:coffee/screens/selection_screen.dart';
import 'package:coffee/screens/config_screen.dart';
import 'package:coffee/screens/favs_screen.dart';
import 'package:coffee/screens/launch.dart';

void main() => runApp(Coffee());

class Coffee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LaunchScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        SelectionScreen.id: (context) => SelectionScreen(),
        ConfigScreen.id: (context) => ConfigScreen(),
        UpdateScreen.id: (context) => UpdateScreen(),
        FavsScreen.id: (context) => FavsScreen(),
        LaunchScreen.id: (context) => LaunchScreen(),
      },
    );
  }
}

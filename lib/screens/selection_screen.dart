import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/screens/config_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee/screens/chat_screen.dart';

class SelectionScreen extends StatefulWidget {
  static const String id = 'selection_screen';
  @override
  _SelectionScreenState createState() {
    return _SelectionScreenState();
  }
}

User loggedInUser;

class _SelectionScreenState extends State<SelectionScreen> {
  final _auth = FirebaseAuth.instance;
  var data;
  String name;
  var amount;
  String thevalue;
  int themath;
  var coffeename;
  var coffeeid;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    getCurrentValue();
  }

  getCurrentValue() async {
    await FirebaseFirestore.instance
        .collection("amount")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        thevalue = result['amount'];
      });
    });

    setState(() {
      return thevalue;
    });
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        RegExp exp = new RegExp(r"([^@]*)");
        String str = loggedInUser.email;
        Iterable<RegExpMatch> matches = exp.allMatches(str);
        var match = matches.elementAt(0);
        var nameuppercase = match.group(1).toString();
        name = nameuppercase[0].toUpperCase() + nameuppercase.substring(1);

        FirebaseFirestore.instance
            .collection("amount")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            thevalue = result['amount'];
          });
        });

        setState(() {
          return name;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onPressedFrisco() async {
      String coffeeid = 'frisco';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Frisco';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/frisco.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedRicoffy() async {
      String coffeeid = 'ricoffy';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Ricoffy';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/ricoffy.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedNescafe() async {
      String coffeeid = 'nescafe';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Nescafe Classic';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/nescafe.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedGold() async {
      String coffeeid = 'gold';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Nescafe Gold';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/gold.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedJacobs() async {
      String coffeeid = 'jacobs';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Jacobs';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/jacobs.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedStarbucks() async {
      String coffeeid = 'starbucks';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Starbucks';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/starbucks.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedCappa() async {
      String coffeeid = 'cappa';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Nescafe Cappuccino';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/cappa.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    void _onPressedGround() async {
      String coffeeid = 'ground';
      SharedPreferences coffee = await SharedPreferences.getInstance();
      coffee.setString('coffeeid', '$coffeeid');

      String coffeename = 'Ground Coffee';
      SharedPreferences coffeenames = await SharedPreferences.getInstance();
      coffeenames.setString('coffeename', '$coffeename');

      String images = 'images/ground.png';
      SharedPreferences image = await SharedPreferences.getInstance();
      image.setString('coffeeimage', '$images');

      Navigator.pushNamed(context, ConfigScreen.id);
    }

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 222, 251, 1),
      appBar: AppBar(
        title: Text('Make Me Coffee!'),
        leading: new Container(),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushNamed(context, ChatScreen.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(25, 117, 210, 1),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(appConfigblockSizeWidth * 6),
                    bottomLeft: Radius.circular(appConfigblockSizeWidth * 6)),
              ),
              child: Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SelectionScreen.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Please choose a coffee...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //First Row

            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius:
                          BorderRadius.circular(appConfigblockSizeWidth * 10),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                        Text(
                          'Some low caffeine and chicory?',
                          style: TextStyle(
                              fontSize: fontSize * 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _onPressedFrisco();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/frisco-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                _onPressedRicoffy();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/ricoffy-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                      ],
                    )),
              ),
            ),

            //Second Row

            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius:
                          BorderRadius.circular(appConfigblockSizeWidth * 10),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                        Text(
                          'How about the Nescafe selection?',
                          style: TextStyle(
                              fontSize: fontSize * 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _onPressedNescafe();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/nescafe-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                _onPressedGold();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/gold-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                      ],
                    )),
              ),
            ),

            //Third Row

            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius:
                          BorderRadius.circular(appConfigblockSizeWidth * 10),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                        Text(
                          'Do you need to get your heart racing?',
                          style: TextStyle(
                              fontSize: fontSize * 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _onPressedJacobs();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/jacobs-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                _onPressedStarbucks();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage: AssetImage(
                                        'images/starbucks-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                      ],
                    )),
              ),
            ),

            //Fourth Row

            Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius:
                          BorderRadius.circular(appConfigblockSizeWidth * 10),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                        Text(
                          'And for the connoisseurs we have...',
                          style: TextStyle(
                              fontSize: fontSize * 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _onPressedCappa();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/cappa-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                _onPressedGround();
                              },
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: appConfigblockSizeWidth * 15,
                                    backgroundImage:
                                        AssetImage('images/ground-button.png'),
                                    backgroundColor:
                                        Color.fromRGBO(25, 117, 210, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: appConfigblockSizeHeight * 4,
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

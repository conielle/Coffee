import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/screens/config_screen.dart';
import 'package:coffee/screens/favs_screen.dart';
import 'package:coffee/screens/selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coffee/components/rounded_button.dart';
import 'package:audioplayers/audio_cache.dart';

import 'selection_screen.dart';

const alarmAudioPath = "siren.mp3";

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() {
    return _ChatScreenState();
  }
}

User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  static AudioCache player = new AudioCache();


  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final _auth = FirebaseAuth.instance;
  var data;
  String coffeevalue;
  var coffeeammount;
  String coffeename;
  String email;
  String name;
  bool milk;
  String thevalue;
  var stream;

  var welcomeList = List.from([
    'images/tracy.png',
    'images/dan.png',
    'images/zoey.png',
    'images/con.png',
    'images/chris.png',
    'images/gerrie.png',
    'images/coen.png',
    'images/ida.png',
    'images/xandri.png',
  ], growable: false);

  random() {
    Random rnd;
    int min = 0;
    int max = 9;
    int r;
    rnd = new Random();
    r = min + rnd.nextInt(max - min);
    print("$r is in the range of $min and $max");

    return r;
  }

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection('coffee').snapshots();
    getToken();
    getCurrentUser();
    firebaseCloudMessaging_Listeners();
    pushNotif();
    iOS_Permission();
    getDataCheck();
    getCurrentEmail();
    getCurrentValue();
    favsVisible();

    super.initState();



  }


  void pushNotif() {
    firebaseMessaging.subscribeToTopic('coffee');
  }

  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        RegExp exp = new RegExp(r"([^@]*)");
        String str = loggedInUser.email;
        email = loggedInUser.email;
        Iterable<RegExpMatch> matches = exp.allMatches(str);
        var match = matches.elementAt(0);
        var nameuppercase = match.group(1).toString();
        name = nameuppercase[0].toUpperCase() + nameuppercase.substring(1);

        setState(() {
          return name;
        });
      }
    } catch (e) {
      print(e);
    }

    firebaseMessaging.getToken().then((token) {
      firebaseMessaging.subscribeToTopic('coffee');

      FirebaseFirestore.instance
          .collection("tokens")
          .doc('$email')
          .update({"token": "$token", "email": '$email', "name": '$name'});
    });

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
      },
      onLaunch: (Map<String, dynamic> message) async {
      },
      onResume: (Map<String, dynamic> message) async {
      },
    );
  }

  void iOS_Permission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  getDataCheck() async {
    await FirebaseFirestore.instance
        .collection("coffee")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        thevalue = result['sender'];
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
        email = loggedInUser.email;
        Iterable<RegExpMatch> matches = exp.allMatches(str);
        var match = matches.elementAt(0);
        var nameuppercase = match.group(1).toString();
        name = nameuppercase[0].toUpperCase() + nameuppercase.substring(1);

        setState(() {
          return name;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCurrentEmail() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        RegExp exp = new RegExp(r"([^@]*)");
        String str = loggedInUser.email;
        email = loggedInUser.email;

        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCurrentValue() async {
    await FirebaseFirestore.instance
        .collection("amount")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        coffeeammount = result['amount'];
      });
    });

    setState(() {
      return coffeeammount;
    });
  }

  void _reset() {
    int addedamount = 0;

    FirebaseFirestore.instance.collection("amount").doc('amount').update({
      "amount": "${addedamount.toString()}",
    });
    setState(() {
      return coffeeammount = addedamount.toString();
    });
  }

  getToken() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        RegExp exp = new RegExp(r"([^@]*)");
        String str = loggedInUser.email;
        email = loggedInUser.email;

        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }
    var token;
    var dbemail;
    var name;

    await FirebaseFirestore.instance
        .collection("tokens")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        token = result['token'];
        dbemail = result['email'];
        name = result['name'];
        print("this is your toke $token");
        print("this is your email $dbemail");
        print("this is your name $name");
      });
    });
  }

  var favvisible;
  favsVisible() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        RegExp exp = new RegExp(r"([^@]*)");
        String str = loggedInUser.email;
        email = loggedInUser.email;

        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }

    FirebaseFirestore.instance
        .collection('config')
        .doc('$email')
        .collection('config')
        .get()
        .then((value) {
      value.docs.forEach((result) {
        favvisible = result.data;
      });

      setState(() {
        return favvisible;
      });
    });
  }

  imComing() async {
    await FirebaseFirestore.instance
        .collection('hurryup')
        .doc('hurryup')
        .delete();
  }

  hurryUp() async {
    FirebaseFirestore.instance.collection("hurryup").doc('hurryup').set({
      "hurryup": "hurryup",
    });
  }

  playSound() async {
    player.play(alarmAudioPath);
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(25, 117, 210, 1),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: appConfigblockSizeWidth * 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${(coffeeammount == null ? 0 : coffeeammount)} Coffee\'s requested today.',
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.autorenew,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: appConfigblockSizeHeight * 7.5,
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
                          Icon(
                            Icons.queue,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: appConfigblockSizeWidth * 4,
                          ),
                          Text(
                            'Request a coffee?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize * 12,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: appConfigblockSizeHeight * 4,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SelectionScreen.id);
                        },
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            Image.asset(
                              welcomeList[random()],
                              height: appConfigblockSizeWidth * 75,
                            )
                          ],
                        )),
                      );
                    } else if (snapshot.data.docs.isEmpty) {
                      return FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SelectionScreen.id);
                        },
                        child: Container(
                            child: Column(
                          children: <Widget>[
                            Image.asset(
                              welcomeList[random()],
                              height: appConfigblockSizeWidth * 75,
                            )
                          ],
                        )),
                      );
                    } else {
                      return Column(
                        children: snapshot.data.docs.reversed.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              height: appConfigblockSizeWidth * 50,
                              width: appConfigblockSizeWidth * 90,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(25, 117, 210, 1),
                                borderRadius: BorderRadius.circular(
                                    appConfigblockSizeWidth * 10),
                              ),
                              child: FlatButton(
                                onLongPress: () async {
                                  (doc.data()['sender'] == 'Coffee Master')
                                      ? {imComing()}
                                      : await FirebaseFirestore.instance
                                          .collection('coffee')
                                          .doc(doc.id)
                                          .delete();
                                  imComing();
                                },
                                child: ListView(children: [
                                  SizedBox(
                                    height: appConfigblockSizeHeight * 2,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${doc.data()['sender']} requests a Coffee!",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: appConfigblockSizeHeight * 3,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            child: new Image.asset(
                                              "${doc.data()['text']}",
                                              scale:
                                                  appConfigblockSizeWidth * 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          (doc.data()['clockwise'] == 'true')
                                              ? Text(
                                                  'Please stir clockwise',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                )
                                              : Text(
                                                  'Please stir anti-clockwise',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                ),
                                          SizedBox(
                                            height:
                                                appConfigblockSizeHeight * 0.5,
                                          ),
                                          (doc.data()['milk'] == 'false')
                                              ? Text(
                                                  'No milk please',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                )
                                              : Text(
                                                  'Some milk please',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                ),
                                          SizedBox(
                                            height:
                                                appConfigblockSizeHeight * 0.5,
                                          ),
                                          (doc.data()['coffee'] == 'null')
                                              ? Text(
                                                  'Just wing it with the coffee',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                )
                                              : (doc.data()['coffee'] == '')
                                                  ? Text(
                                                      'Just wing it with the coffee',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              fontSize * 7),
                                                    )
                                                  : (doc.data()['Coffee'] ==
                                                          '0')
                                                      ? Text(
                                                          'Just wing it with the coffee',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  fontSize * 7),
                                                        )
                                                      : (doc.data()['Coffee'] ==
                                                              '0.5')
                                                          ? Text(
                                                              'Half a teaspoon coffee',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      fontSize *
                                                                          7),
                                                            )
                                                          : (doc.data()[
                                                                      'Coffee'] ==
                                                                  '1')
                                                              ? Text(
                                                                  'One teaspoon of Coffee',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          fontSize *
                                                                              7),
                                                                )
                                                              : (doc.data()[
                                                                          'Coffee'] ==
                                                                      'one')
                                                                  ? Text(
                                                                      'One teaspoon of Coffee',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              fontSize * 7),
                                                                    )
                                                                  : Text(
                                                                      "${doc.data()['coffee']} teaspoons coffee",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              fontSize * 7),
                                                                    ),
                                          SizedBox(
                                            height:
                                                appConfigblockSizeHeight * 0.5,
                                          ),
                                          (doc.data()['sugar'] == 'null')
                                              ? Text(
                                                  'Nope! No sugar thanks',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                )
                                              : (doc.data()['sugar'] == '0')
                                                  ? Text(
                                                      'Nope! No sugar thanks',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              fontSize * 7),
                                                    )
                                                  : Text(
                                                      "Could I have ${doc.data()['sugar']} sugars please",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              fontSize * 7),
                                                    ),
                                          SizedBox(
                                            height:
                                                appConfigblockSizeHeight * 0.5,
                                          ),
                                          (doc.data()['sweetner'] == 'null')
                                              ? Text(
                                                  'Nope! No sweetner thanks',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSize * 7),
                                                )
                                              : (doc.data()['sweetner'] == '0')
                                                  ? Text(
                                                      'Nope! No sweetner thanks',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              fontSize * 7),
                                                    )
                                                  : Text(
                                                      "${doc.data()['sweetner']} sweetners please",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              fontSize * 7),
                                                    ),
                                          SizedBox(
                                            height:
                                                appConfigblockSizeHeight * 0.5,
                                          ),
                                          Text(
                                            'Thank you kindly.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fontSize * 6),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }),
              RoundedButton(
                  title: 'Whats Taking So Long?',
                  colour: Color.fromRGBO(25, 117, 210, 1),
                  onPressed: () {
                    hurryUp();
                  }),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('config')
                        .doc('$email')
                        .collection('config')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Container(
                            height: appConfigblockSizeHeight * 30,
                            width: appConfigblockSizeWidth * 90,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: appConfigblockSizeHeight * 0.5,
                                ),
                                (favvisible == null)
                                    ? SizedBox()
                                    : Text(
                                        'Your favourites are scrollable below',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(25, 117, 210, 1),
                                            fontSize: fontSize * 6,
                                            fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: appConfigblockSizeHeight * 1.5,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: snapshot.data.docs.map((doc) {
                                        return Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 15),
                                              child: Container(
                                                height:
                                                    appConfigblockSizeWidth *
                                                        22,
                                                width: appConfigblockSizeWidth *
                                                    22,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      25, 117, 210, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          appConfigblockSizeWidth *
                                                              15),
                                                ),
                                                child: FlatButton(
                                                  onPressed: () async {
                                                    coffeevalue =
                                                        doc.data()['id'];
                                                    coffeename =
                                                        doc.data()['name'];

                                                    SharedPreferences coffee =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    coffee.setString('coffeeid',
                                                        '$coffeevalue');

                                                    SharedPreferences
                                                        coffeenames =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    coffeenames.setString(
                                                        'coffeename',
                                                        '$coffeename');

                                                    SharedPreferences image =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    image.setString(
                                                        'coffeeimage',
                                                        'images/${coffeevalue}.png');

                                                    Navigator.pushNamed(context,
                                                        ConfigScreen.id);
                                                  },
                                                  child: ListView(children: [
                                                    Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height:
                                                                appConfigblockSizeWidth *
                                                                    4,
                                                          ),
                                                          Image.asset(
                                                            'images/${doc.data()['id']}.png',
                                                            scale:
                                                                appConfigblockSizeWidth *
                                                                    2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: Text('Request a Coffee!'),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FavsScreen.id);
        },
        child: Icon(
          Icons.settings,
        ),
      ), // This trailing
    );
  }
}

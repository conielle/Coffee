import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee/components/rounded_button.dart';
import 'package:coffee/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ConfigScreen extends StatefulWidget {
  static const String id = 'config_screen';
  @override
  _ConfigScreenState createState() {
    return _ConfigScreenState();
  }
}

User loggedInUser;

class _ConfigScreenState extends State<ConfigScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = true;
  String name;
  String email;
  String sugar;
  String coffeeamount;
  String sweetner;
  String coffeeid;
  String coffeename;
  bool milk = false;
  bool clockwise = true;
  String images;
  bool exists = false;
  int themath;
  var thevalue;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    getTitle();
    checkCoffee();

    getCoffee();
  }

  var theval;
  var cofid;



  getTitle() async {
    SharedPreferences coffeenames = await SharedPreferences.getInstance();
    coffeename = coffeenames.getString('coffeename') ?? '';


    print(coffeename);
    setState(() {
      print(coffeename);
      return coffeename;
    });
  }

  checkCoffee() async {

    await FirebaseFirestore.instance.collection("amount").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        theval = result.data()['amount'];
      });
    });
    SharedPreferences coffee = await SharedPreferences.getInstance();
    cofid = coffee.getString('coffeeid') ?? '';

    print("$coffeeid is the ID");

    setState(() {
      thevalue = theval;
      coffeeid = cofid;
    });

    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email;
        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }

    try {
      await FirebaseFirestore.instance.collection("config").doc("$email").collection("config").doc("$coffeeid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      if (exists == true){
        print("Making Coffee Request");
      setExisitingCoffee();
      } else {

        print("Customize Coffee");
        setState(() {
          showSpinner = false;
        });

      }
      print(exists);
    } catch (e) {
      print('error');
      return false;
    }
  }
  var data;
  var camount;
  var csugar;
  var csweetner;
  var cmilk;
  var cclockwise;

  setExisitingCoffee()async{
    DocumentReference document = await FirebaseFirestore.instance.collection("config").doc("$email").collection("config").doc("$coffeeid").get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        camount = documentSnapshot.data()['coffee'];
        csugar = documentSnapshot.data()['sugar'];
        csweetner = documentSnapshot.data()['sweetner'];
        cmilk = documentSnapshot.data()['milk'];
        cclockwise = documentSnapshot.data()['clockwise'];
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
    print('gets here');

    //
    //
    // var camount = data['coffee'];
    // var csugar = data['sugar'];
    // var csweetner = data['sweetner'];
    // var cmilk = data['milk'];
    // var cclockwise = data['clockwise'];
    //
    //
    //
    //
    FirebaseFirestore.instance
        .collection("coffee")
        .add({"sender": "$name", "text": 'images/$coffeeid.png', 'coffee': '$camount',"sugar": '$csugar', "sweetner": '$csweetner', "milk": '$cmilk', 'clockwise': '$cclockwise', 'type': '$coffeename' }).then((value) {
      print(value.id);
    });

    themath = int.parse(thevalue);
    int addedamount =  themath + 1;

    FirebaseFirestore.instance
        .collection("amount").doc('amount').update({"amount": "${addedamount.toString()}",});
    setState(() {
      return thevalue = addedamount.toString();
    });

    Navigator.pushNamed(context, ChatScreen.id);

  }

  setCoffee() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email;
        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }

    String pulledname;


    SharedPreferences coffee = await SharedPreferences.getInstance();
    coffeeid = coffee.getString('coffeeid') ?? '';


    pulledname = coffeeid;

    await FirebaseFirestore.instance
        .collection('config')
        .doc("$email")
        .collection('config').doc('$coffeeid')
        .set({
      'id': '$pulledname',
      'name': '$coffeename',
      'text': 'images/$coffeeid.png',
      'coffee': '$coffeeamount',
      'sugar': "$sugar", 'sweetner': "$sweetner", 'milk': "$milk", 'clockwise': '$clockwise', 'type': '$coffeename'
    }).then((onValue) {
      print('Created it in sub collection');
    }).catchError((e) {
      print('======Error======== ' + e);
    });

    FirebaseFirestore.instance
        .collection("coffee")
        .add({"sender": "$name", "text": 'images/$coffeeid.png', 'coffee': '$coffeeamount',"sugar": '$sugar', "sweetner": '$sweetner', "milk": '$milk', 'clockwise': '$clockwise', 'type': '$coffeename'}).then((value) {
      print(value.id);
    });


    themath = int.parse(thevalue);
    int addedamount =  themath + 1;

    FirebaseFirestore.instance
        .collection("amount").doc('amount').update({"amount": "${addedamount.toString()}",});
    setState(() {
      return thevalue = addedamount.toString();
    });


    Navigator.pushNamed(context, ChatScreen.id);
  }

  getCoffee() async {

    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email;
        setState(() {
          return email;
        });
      }
    } catch (e) {
      print(e);
    }


    SharedPreferences coffee = await SharedPreferences.getInstance();
    coffeeid = coffee.getString('coffeeid') ?? '';

    SharedPreferences image = await SharedPreferences.getInstance();
    images = image.getString('coffeeimage') ?? '';


    setState(() {
      return images;
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

  @override
  Widget build(BuildContext context) {

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 222, 251, 1),
      appBar: AppBar(title: Text('I Like It Like This'), leading: new Container(),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () { Navigator.pushNamed(context, ChatScreen.id);
            },
          ),],
      ),
      body:

      ModalProgressHUD(
          inAsyncCall: showSpinner,
              child: SingleChildScrollView(
                child: Container(
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
                              SizedBox(height: appConfigblockSizeHeight * 1,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('How do you want your $coffeename?', style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              SizedBox(height: appConfigblockSizeHeight * 1,),
                            ],
                          ),
                        ),
                        SizedBox(height: appConfigblockSizeHeight * 1,),
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                          child: Container(

                            child: Column(children: <Widget>[
                              Container(
                                  height: appConfigblockSizeHeight * 25,
                                  child: Image.asset('$images')),

                              SizedBox(height: appConfigblockSizeHeight * 1,),

                              TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  coffeeamount = value;
                                },
                                decoration:
                                kTextFieldDecoration.copyWith(hintText: 'Teaspoons of coffee?'),
                              ),

                              SizedBox(height: appConfigblockSizeHeight * 1,),

                              TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  sugar = value;
                                },
                                decoration:
                                kTextFieldDecoration.copyWith(hintText: 'How many sugars?'),
                              ),
                              SizedBox(height: appConfigblockSizeHeight * 1,),
                              TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  sweetner = value;
                                },
                                decoration:
                                kTextFieldDecoration.copyWith(hintText: 'How many sweetners?'),
                              ),
                              SizedBox(height: appConfigblockSizeHeight * 1,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Container(

                                  child: Column(children: <Widget>[

                                    Row(
                                      children: <Widget>[
                                        Switch(
                                            value: milk,
                                            onChanged: (value) {
                                              setState(() {
                                                milk = value;
                                              });
                                            }),
                                        Text('Would you like some milk?', style: TextStyle(fontSize: fontSize * 6),)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Switch(
                                            value: clockwise,
                                            onChanged: (value) {
                                              setState(() {
                                                clockwise = value;
                                              });
                                            }),
                                        Text('Stir clockwise?', style: TextStyle(fontSize: fontSize * 6),)
                                      ],
                                    ),

                                  ],),),
                              ),

                              RoundedButton(
                                  title: 'How I Like It!',
                                  colour: Colors.blueAccent,
                                  onPressed: () {setCoffee();
                                  }
                              ),

                            ],),),
                        ),
                      ],
                    )),
              )
             ),
      );
  }
}

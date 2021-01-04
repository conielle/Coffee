import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/screens/chat_screen.dart';
import 'package:coffee/screens/favs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee/components/rounded_button.dart';
import 'package:coffee/constants.dart';

class UpdateScreen extends StatefulWidget {
  static const String id = 'update_screen';
  @override
  _UpdateScreenState createState() {
    return _UpdateScreenState();
  }
}

User loggedInUser;

class _UpdateScreenState extends State<UpdateScreen> {
  final _auth = FirebaseAuth.instance;
  var data;
  bool thevalue = false;
  bool anothervalue = false;
  var bmilk;
  var bclockwise;
  var dmilk;
  var dclockwise;
  String name;
  String email;
  String coffeeamount;
  String sugar;
  String sweetner;
  String coffeeid;
  String imagedisplay;
  String coffeename;
  String ccoffeename;
  String title;
  bool milk = false;
  bool clockwise = true;
  String images;
  var camount;
  var csugar;
  var csweetner;
  var cmilk;
  var cclockwise;


  @override
  void initState() {
    super.initState();
    readCoffeeSettings();
    getID();
    getTitle();
    getCoffee();
  }

  getID() async {
    SharedPreferences coffee = await SharedPreferences.getInstance();
    coffeeid = coffee.getString('coffeeupdate') ?? '';

    imagedisplay = 'images/$coffeeid.png';
    setState(() {
      print(imagedisplay);
      return imagedisplay;
    });
  }

  getTitle() async {
    SharedPreferences coffeenames = await SharedPreferences.getInstance();
    coffeename = coffeenames.getString('coffeename') ?? '';


    print(coffeename);
    setState(() {
      print(coffeename);
      return coffeename;
    });
  }




  readCoffeeSettings()async{


    SharedPreferences coffee = await SharedPreferences.getInstance();
    var coffeeupdate = coffee.getString('coffeeupdate') ?? '';


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

    print(coffeeupdate);
    print(email);



    DocumentReference document = await FirebaseFirestore.instance.collection("config").doc("$email").collection("config").doc("$coffeeid").get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {


        ccoffeename = documentSnapshot.data()['name'];
        camount = documentSnapshot.data()['coffee'];
        csugar = documentSnapshot.data()['sugar'];
        csweetner = documentSnapshot.data()['sweetner'];
        cmilk = documentSnapshot.data()['milk'];
        cclockwise = documentSnapshot.data()['clockwise'];

        print('gets here');

        if (cmilk == 'true'){thevalue = true;} else {thevalue = false;}
        if (cclockwise == 'true'){anothervalue = true;} else {anothervalue = false;}

        setState(() {
          camount;
          csugar;
          csweetner;
          ccoffeename;
          thevalue;
          anothervalue;
        });



        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });



    // final DocumentReference document = FirebaseFirestore.instance.collection("config").doc('$email').collection('config').doc('$coffeeupdate');
    // await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
    //   setState(() {
    //     data = snapshot.data;
    //   });
    // });

    // bool thevalue = false;
    // bool anothervalue = false;
    // ccoffeename = data['name'];
    // camount = data['coffee'];
    // csugar = data['sugar'];
    // csweetner = data['sweetner'];
    // var bmilk = data['milk'];
    // var bclockwise = data['clockwise'];
    //
    // if (bmilk == 'true'){thevalue = true;} else {thevalue = false;}
    // if (bclockwise == 'true'){anothervalue = true;} else {anothervalue = false;}
    //
    // setState(() {
    //   camount;
    //   csugar;
    //   csweetner;
    //   ccoffeename;
    //   cmilk = thevalue;
    //   cclockwise = anothervalue;
    // });
  }


  removeCoffee() async {
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
    coffeeid = coffee.getString('coffeeupdate') ?? '';


    pulledname = coffeeid;

    await FirebaseFirestore.instance
        .collection('config')
        .doc("$email")
        .collection('config').doc('$coffeeid')
        .delete();

    Navigator.pushNamed(context, FavsScreen.id);
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
    coffeeid = coffee.getString('coffeeupdate') ?? '';


    pulledname = coffeeid;

    await FirebaseFirestore.instance
        .collection('config')
        .doc("$email")
        .collection('config').doc('$coffeeid')
        .set({
      'id': '$pulledname',
      'name': '$coffeename',
      'coffee': '${(coffeeamount == null) ? camount : (coffeeamount == '0') ? camount : coffeeamount}',
      'text': 'images/$coffeeid.png',
      'sugar': "${(sugar == null) ? csugar : sugar}",
      'sweetner': "${(sweetner == null) ? csweetner : sweetner}",
      'milk': "$thevalue",
      'clockwise': '${anothervalue}',
    }).then((onValue) {
      print('Created it in sub collection');
    }).catchError((e) {
      print('======Error======== ' + e);
    });

    Navigator.pushNamed(context, FavsScreen.id);
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




  @override
  Widget build(BuildContext context) {

    double appConfigWidth = MediaQuery.of(context).size.width;
    double appConfigHeight = MediaQuery.of(context).size.height;
    double appConfigblockSizeWidth = appConfigWidth / 100;
    double appConfigblockSizeHeight = appConfigHeight / 100;
    double fontSize = appConfigWidth * 0.005;

    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 222, 251, 1),
      appBar: AppBar(title: Text('Change Coffee Makeup'), leading: new Container(),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () { Navigator.pushNamed(context, FavsScreen.id);
            },
          ),],

      ),
      body: SingleChildScrollView(
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
                  SizedBox(height: appConfigblockSizeHeight * 2,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[(ccoffeename == null) ? Text('Customize your Coffee', style: TextStyle(color: Colors.white)) :
                      Text('How do you want your $ccoffeename', style: TextStyle(color: Colors.white),),
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
                      child: Image.asset('$imagedisplay')),

                SizedBox(height: appConfigblockSizeHeight * 1,),

                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      coffeeamount = value;
                    },
                    decoration:
                    kTextFieldDecoration.copyWith(hintText: (camount == 'null') ? 'No Coffee?' : (camount == '0') ? 'No Coffee?' : (camount == '1') ? '1 teaspoons' :'$camount teaspoons'),
                  ),
                SizedBox(height: appConfigblockSizeHeight * 1,),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    sugar = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: (csugar == 'null') ? 'No sugar' : (csugar == '0') ? 'No sugar' : (csugar == '1') ? '1 sugar' : '$csugar sugars'),
                ),
                SizedBox(height: appConfigblockSizeHeight * 1,),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    sweetner = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: (csweetner == 'null') ? 'No sweetner' : (csweetner == '0') ? 'No sweetner' : (csweetner == '1') ? '1 sweetner' :'$csweetner sweetners'),
                ),
                SizedBox(height: appConfigblockSizeHeight * 1,),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(

                    child: Column(children: <Widget>[

                    Row(
                      children: <Widget>[
                        Switch(
                            value: thevalue,
                            onChanged: (value) {
                              setState(() {
                                thevalue = value;
                              });
                            }),
                        Text('Would you like some milk?', style: TextStyle(fontSize: fontSize * 6),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Switch(
                            value: anothervalue,
                            onChanged: (value) {
                              setState(() {
                                anothervalue = value;
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
                  RoundedButton(
                      title: 'Remove!',
                      colour: Colors.blueAccent,
                      onPressed: () {removeCoffee();
                      }
                  ),

              ],),),
            ),
          ],
        )),
      ),
    );
  }
}

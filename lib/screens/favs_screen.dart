import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee/screens/chat_screen.dart';
import 'package:coffee/screens/config_screen.dart';
import 'package:coffee/screens/selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee/screens/update_screen.dart';
import 'package:coffee/components/rounded_button.dart';
import 'package:coffee/constants.dart';

class FavsScreen extends StatefulWidget {
  static const String id = 'favs_screen';
  @override
  _FavsScreenState createState() {
    return _FavsScreenState();
  }
}

User loggedInUser;

class _FavsScreenState extends State<FavsScreen> {
  final _auth = FirebaseAuth.instance;
  var data;
  String coffeevalue;
  String email;
  String name;
  bool milk;



  @override
  void initState() {
    super.initState();
    getCurrentUser();
    favsVisible();
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

    FirebaseFirestore.instance.collection('config').doc('$email').collection('config').get().then((value) {

      value.docs.forEach((result) {
        favvisible = result.data;
      });

      setState(() {
        print('this is $favvisible');
        return favvisible;
      });

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
      appBar: AppBar(title: Text('How I Like My Coffee'), leading: new Container(), actions: <Widget>[
      // action button
      IconButton(
      icon: Icon(Icons.close),
      onPressed: () { Navigator.pushNamed(context, ChatScreen.id);
      },
    ),],),
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
                  FlatButton(
                    onPressed: (){},
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[(favvisible == null) ?  Text('No Coffee to update...', style: TextStyle(color: Colors.white),) :
                        Text('Tap a Coffee to update it', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  )
                ],
              ),
            ),
           Container(child:  (favvisible == null) ?
           Column(children: <Widget>[
             SizedBox(height: appConfigblockSizeHeight * 5,),
             Image.asset('images/logo.png', scale: 5,),
             RoundedButton(
                 title: 'Request A Coffee',
                 colour: Colors.blueAccent,
                 onPressed: () {
                   Navigator.pushNamed(context, SelectionScreen.id);
                 }
             ),

             RoundedButton(
                 title: 'Go Home',
                 colour: Colors.blueAccent,
                 onPressed: () {
                   Navigator.pushNamed(context, ChatScreen.id);
                 }
             ),

           ],) : SizedBox(),),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('config').doc('$email').collection('config').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.docs.map((doc) {
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
                              onPressed: () async {
                                coffeevalue = doc.data()['id'];

                                SharedPreferences coffee =
                                await SharedPreferences.getInstance();
                                coffee.setString('coffeeupdate', '$coffeevalue');
//
                              print(coffeevalue);
                                Navigator.pushNamed(context, UpdateScreen.id);

                              },
                              child: ListView(children: [
                                SizedBox(
                                  height: appConfigblockSizeHeight * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                   Text(
                                            "I like my ${doc.data()['name']} like this:",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                  ],
                                ),
                                SizedBox(height: appConfigblockSizeHeight * 3,),
                                Row(children: <Widget>[Column(children: <Widget>[

                                  Container(
                                    child: new Image.asset(
                                      "${doc.data()['text']}",
                                      scale: appConfigblockSizeWidth * 1.2,
                                    ),
                                  ),

                                ],),Column(
                                  children: <Widget>[
                                    (doc.data()['clockwise'] == 'true') ?  Text('I like it stirred clockwise', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : Text('I like it stirred anti-clockwise', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),),
                                    SizedBox(height: appConfigblockSizeHeight * 1,),
                                    (doc.data()['milk'] == 'false') ? Text('I don\'t like milk', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : Text('I like some milk', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),),
                                    SizedBox(height: appConfigblockSizeHeight * 0.5,),
                                    (doc.data()['coffee'] == 'null') ? Text('Just wing it with the coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['coffee'] == '') ? Text('Just wing it with the coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['Coffee'] == '0') ? Text('Just wing it with the coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['Coffee'] == '0.5') ? Text('Half a teaspoon coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['Coffee'] == '1') ? Text('One teaspoon of Coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['Coffee'] == 'one') ? Text('One teaspoon of Coffee', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : Text("${doc.data()['coffee']} teaspoons coffee", style: TextStyle(color: Colors.white, fontSize: fontSize * 7),),
                                    SizedBox(height: appConfigblockSizeHeight * 1,),
                                    (doc.data()['sugar'] == 'null') ? Text('I don\'t like sugar', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['sugar'] == '0') ? Text('I don\'t like sugar', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : Text("I like ${doc.data()['sugar']} sugars", style: TextStyle(color: Colors.white, fontSize: fontSize * 7),),
                                    SizedBox(height: appConfigblockSizeHeight * 1,),
                                    (doc.data()['sweetner'] == 'null') ? Text('I don\'t like sweetner', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : (doc.data()['sweetner'] == '0') ? Text('I don\'t like sweetner', style: TextStyle(color: Colors.white, fontSize: fontSize * 7),) : Text("I like ${doc.data()['sweetner']} sweetners", style: TextStyle(color: Colors.white, fontSize: fontSize * 7),),
                                    SizedBox(height: appConfigblockSizeHeight * 1,),

                                  ],


                                )],)
                              ]),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            SizedBox(
              height: appConfigblockSizeHeight * 5,
            ),
          ],
        )),
      ),
    );
  }
}

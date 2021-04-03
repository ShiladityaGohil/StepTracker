//import 'dart:async';
//import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:steptracker/controllers/authentication.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:steptracker/main.dart';
import 'package:steptracker/pages/loginScreen.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email;
  String password;
  // ignore: deprecated_member_use
  List<Map<String,dynamic>> history=new List<Map<String,dynamic>>();
  String name;
  // ignore: deprecated_member_use
  List<String> frilist=new List<String>();
 // Map<int,String> frilist;
  final db = Firestore.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void handleSignup() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signUp(email.trim(), password, context).then((user) async {
        if (user != null) {
          await db.collection('users').document(user.uid).setData({
            "steps": 0,
            'name': name,
            'email':email,
            'goal': 0,
            'comment': '',
            'uid': user.uid,
            'coins': '0',
            'friends': frilist,
            'height': 0,
            'weight': 0,
            'history':history
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(uid: user.uid),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FlutterLogo(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Signup Here",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Nick Name"),
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required."),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required.")
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: handleSignup,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /* MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => googleSignIn().whenComplete(() async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Homepage(uid: user.uid)));
                }),
                child: Image(
                  image: AssetImage('assets/signin.png'),
                  width: 200.0,
                ),
              ), */
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Have an Account?",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

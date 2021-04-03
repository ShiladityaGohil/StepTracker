import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steptracker/controllers/authentication.dart';
import 'package:steptracker/main.dart';
import 'package:steptracker/pages/signupScreen.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signin(email, password, context).then((value) {
        if (value!=null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(uid: value.uid),
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
              FlutterLogo(
                size: 50.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Login Here",
                  style: TextStyle(
                    fontSize: 30.0,color: Colors.white,
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
                        style: TextStyle(color: Colors.white,fontSize: 25),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required"),
                          EmailValidator(errorText: "Invalid Email Address"),
                        ]),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: true,    
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white,fontSize: 25),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Password Is Required"),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required"),
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password?",style: TextStyle(color:Colors.white,fontSize: 15))),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgotPasswordScreen()));
                        },
                      ),
                      SizedBox(height:20),
                      RaisedButton(
                        // passing an additional context parameter to show dialog boxs
                        onPressed: login,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Login",style: TextStyle(color:Colors.white,fontSize: 20)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             /*  MaterialButton(
                  padding: EdgeInsets.zero,
                  color: Colors.blueAccent,
                  onPressed: () => googleSignIn().whenComplete(() async {
                        FirebaseUser user =
                            await FirebaseAuth.instance.currentUser();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Homepage(uid: user.uid)));
                      }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Image.asset(
                        'Assets/google.png',
                        height: 48.0,
                      ),
                      new Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Text(
                            "Sign in with Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )), */
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  "Haven't an Account?",style: TextStyle(color:Colors.white,fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

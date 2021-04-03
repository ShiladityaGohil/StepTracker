import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:steptracker/pages/loginScreen.dart';
import 'package:steptracker/screen1.dart';
import 'package:google_fonts/google_fonts.dart';

const String boxname='';
Future<void> main() async {
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.darkerGrotesqueTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.darkerGrotesqueTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home:Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {
  final String uid;

  const Homepage({Key key, this.uid}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState(uid);
}

class _HomepageState extends State<Homepage> {
  final String uid;
  _HomepageState(this.uid);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          return Screen1(user: user);
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
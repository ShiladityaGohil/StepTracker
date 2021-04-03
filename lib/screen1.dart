import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:steptracker/pages/loginScreen.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steptracker/screens/Profile.dart';
import 'package:steptracker/screens/coin.dart';
import 'package:steptracker/screens/friends.dart';
import 'package:steptracker/screens/goal.dart';

class Screen1 extends StatefulWidget {
  final FirebaseUser user;

  const Screen1({Key key, this.user}) : super(key: key);
  @override
  _Screen1State createState() => _Screen1State(user);
}

class _Screen1State extends State<Screen1> {
  final FirebaseUser user;
  Map<String, double> userLocation;
  int currentindex = 0;
  double height = 0, weight = 0, tmp = 1;
  String totalkm = '0', totalcal = '0', theight = '', tweight = '';
  final PageController _pageController = PageController();
  String name;
  _Screen1State(this.user);

  final db = Firestore.instance;
  Future getdata() async {
    /* QuerySnapshot r =
        await Firestore.instance.collection('users').getDocuments();
        DocumentReference df= Firestore.instance.collection('users').document();
      int i=0,index;
       */

    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(user.uid).get();

    await document.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        step = await snapshot.data['steps'];
        name = await snapshot.data['name'];
        theight = await snapshot.data['height'];
        tweight = await snapshot.data['weight'];
        height = double.parse(theight);
        weight = double.parse(tweight);
      });
    });
    // step =await r.;
  }

  int step;
  @override
  void initState() {
    super.initState();
    getdata();
    //getLocation();

    ShakeDetector sd = ShakeDetector.waitForStart(onPhoneShake: () {
      setState(() {
        getdata();
        //_getLocation();

        step++;
        totalkm = ((step * 0.73) / 1000).toStringAsFixed(2);
        totalcal = ((step * weight * height * 25) / (1000 * 45 * 162.7))
            .toStringAsFixed(2);
        db.collection('users').document(user.uid).updateData({'steps': step});
      });
    });
    setState(() {
      sd.startListening();
    });
  }

  Widget gradientShaderMask({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.orange,
          Colors.deepOrange.shade900,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  Widget gradientShaderMask2({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.green[300], Colors.green[800]],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  Widget gradientShaderMask3({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.orange[800],
          Colors.orange[800],
          Colors.yellow[600],
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  Widget home() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Hello $name ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        Card(
          color: Colors.grey[900],

          //color: Colors.black87.withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              child: Column(
                children: <Widget>[
                  gradientShaderMask(
                    child: Text(
                      '$step',
                      style: GoogleFonts.darkerGrotesque(
                        fontSize: 120,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    "Total Steps ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              step++;

              db
                  .collection('users')
                  .document(user.uid)
                  .updateData({'steps': step});
            });
          },
          child: Icon(Icons.add),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 190.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.grey[700],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('Assets/road.png'),
                      ),
                      Text('Total Distance',
                          style: GoogleFonts.kaushanScript(
                              fontSize: 25, color: Colors.white)),
                      gradientShaderMask2(
                        child: Text('$totalkm Km',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 190.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.grey[700],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'Assets/Calories.png',
                          height: 100,
                        ),
                      ),
                      Text('Total Calories',
                          style: GoogleFonts.kaushanScript(
                              fontSize: 25, color: Colors.white)),
                      gradientShaderMask3(
                        child: Text('$totalcal cal',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RefreshIndicator(
          onRefresh: () {
            return getdata();
          },
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              backgroundColor: Colors.grey[700],
              title: Text(
                "Daily Steps Tracker",
                style: GoogleFonts.darkerGrotesque(fontSize: 40),
              ),
              centerTitle: true,
              elevation: 10,
              // ignore: deprecated_member_use
              leading: RaisedButton(
                  child: Icon(
                    Icons.circle,
                    color: Colors.white,
                  ),
                  color: Colors.grey[700],
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }),
            ),
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: currentindex,
              backgroundColor: Colors.grey,
              onItemSelected: (index) {
                setState(() {
                  currentindex = index;
                  _pageController.jumpToPage(index);
                });
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text(
                    '  Home',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue[800]),
                  ),
                  activeColor: Colors.blue[800],
                  inactiveColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.assistant_photo),
                  title: Text(
                    '  Goal',
                    style: TextStyle(fontSize: 20),
                  ),
                  activeColor: Colors.red[900],
                  inactiveColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.people),
                  title: Text(
                    '  Friends',
                    style: TextStyle(fontSize: 20, color: Colors.yellow[600]),
                  ),
                  activeColor: Colors.yellow[600],
                  inactiveColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.money_rounded),
                  title: Text(
                    '  ST Store',
                    style: TextStyle(fontSize: 20),
                  ),
                  activeColor: Colors.green[800],
                  inactiveColor: Colors.white,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.account_circle_rounded),
                  title: Text(
                    '  profile',
                    style: TextStyle(fontSize: 20),
                  ),
                  activeColor: Colors.orange[200],
                  inactiveColor: Colors.white,
                ),
              ],
            ),
            body: PageView(
              controller: _pageController,
              children: <Widget>[
                home(),
                Goal(uid: user.uid),
                Friends(uid: user.uid),
                Coins(uid: user.uid),
                Profile(
                    user: user, name: name, height: theight, weight: tweight),
              ],
              onPageChanged: (pageIndex) {
                setState(() {
                  currentindex = pageIndex;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

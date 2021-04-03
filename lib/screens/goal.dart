import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'package:shake/shake.dart';
import 'package:steptracker/screens/History.dart';
import 'package:steptracker/screens/friends.dart';
import 'package:intl/intl.dart';

class Goal extends StatefulWidget {
  final String uid;

  const Goal({Key key, this.uid}) : super(key: key);

  @override
  _GoalState createState() => _GoalState(uid);
}

class _GoalState extends State<Goal> {
  final db = Firestore.instance;
  Position position;
  String g, comment;
  Timer timer;
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> history = new List<Map<String, dynamic>>();
  int startflag = 0;
  int goalstep = 0;
  // ignore: unused_field
  String _buttonText = "Start";
  TextEditingController goalcontroller = TextEditingController();
  TextEditingController commentcontroller = TextEditingController();

  String _stopwatchText = "00:00:00";
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  double _percentage = 0;
  int flag = 1;
  String per = '0.0';
  Color sbcolor = Colors.green[500];
  String gc;
  int sec = 30;
  String coins = '0';
  double tmpcoins = 0;
  final String uid;
  _GoalState(this.uid);

  void initState() {
    super.initState();
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(uid).get();
    document.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        coins = await snapshot.data['coins'];
        tmpcoins = double.parse(coins);
      });
    });

    ShakeDetector sd = ShakeDetector.waitForStart(onPhoneShake: () {
      if (startflag == 1) {
        if (mounted) {
          setState(() async {
            goalstep++;
            tmpcoins += 0.001;
            coins = (tmpcoins).toStringAsFixed(3);
            db.collection('users').document(uid).updateData({'coins': coins});

            int tmp = int.parse(gc);
            //~
            _percentage = ((goalstep) / (tmp));
            per = (_percentage * 100).toStringAsFixed(1);

            if (_percentage >= 1) {
              _percentage = 1;
              per = '100.0';
            }
            if (_percentage >= 1 && flag == 1) {
              _showDialog(context);
              flag = 0;
              _percentage = 1;
              per = '100.0';
            }
          });
        }
      }
    });
    setState(() {
      sd.startListening();
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Awesome!",
            style: GoogleFonts.roboto(fontSize: 40, color: Colors.white),
          ),
          content: new Text(
            "You just surpassed your GOAL!!!",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: 300.0,
                  height: 60,
                  child: TextFormField(
                      controller: commentcontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Publish Goalsteps'),
                      style: TextStyle(
                          fontSize: 23.0, height: 1.0, color: Colors.white))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              // ignore: deprecated_member_use
              child: FlatButton(
                  color: Colors.blueGrey,
                  onPressed: () async {
                    comment = commentcontroller.text;
                    await db
                        .collection('users')
                        .document(uid)
                        .updateData({'goal': goalstep});
                    await db
                        .collection('users')
                        .document(uid)
                        .updateData({'comment': commentcontroller.text});
                    commentcontroller.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Friends(uid: uid),
                        ));
                  },
                  child: Text(
                    'PUBLISH',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              child: Center(
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.red[400],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    goalcontroller.dispose();
    super.dispose();
  }

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _buildBody(),
    );
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
        colors: [Colors.blue[200], Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
          child: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 350, top: 40),
              child: Container(
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => History(uid: uid)));
                    },
                    child: Icon(
                      Icons.history,
                      size: 40,
                    )),
              )),
          Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              new CircularPercentIndicator(
                radius: 350.0,
                lineWidth: 30.0,
                animation: false,
                percent: _percentage,
                center: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 68.0),
                      child: gradientShaderMask(
                        child: Text(
                          '$goalstep',
                          style: GoogleFonts.darkerGrotesque(
                            fontSize: 100,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    new Text(
                      'Goal steps',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white),
                    ),
                    new Text(
                      '$per %',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white),
                    ),
                  ],
                ),
                footer: new Text(
                  _stopwatchText,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 47.0,
                      color: Colors.white),
                ),

                circularStrokeCap: CircularStrokeCap.round,
                //progressColor: Colors.purple,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 150,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: _resetButtonPressed,
                        child: Text(
                          "RESET",
                          style: GoogleFonts.fredokaOne(
                              color: Colors.blue[100], fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: 70,
                      child: TextFormField(
                          controller: goalcontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Set Your Today's Goal"),
                          style: TextStyle(
                              fontSize: 40.0,
                              height: 1.0,
                              color: Colors.white))),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ClipOval(
                      child: Material(
                        color: sbcolor, // button color
                        child: InkWell(
                          splashColor: Colors.greenAccent, // inkwell color
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: Icon(Icons.arrow_right_alt_rounded),
                          ),
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            _startStopButtonPressed();
                            sbcolor = Colors.red;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              /* MaterialButton(
              onPressed: () {
                setState(() {
                  _showDialog(context);
                  goalstep++;
                  int tmp = int.parse(gc);

                  _percentage = ((goalstep) / (tmp));
                  per = (_percentage * 100).toStringAsFixed(1);

                  if (_percentage >= 1) {
                    _percentage = 1;
                    per = '100.0';
                  }
                  if (_percentage >= 1 && flag == 1) {
                    _showDialog(context);
                    flag = 0;
                    _percentage = 1;
                    per = '100.0';
                  }
                  db
                      .collection('users')
                      .document(uid)
                      .updateData({'goal': goalstep});
                });
              },
              child: Icon(Icons.add),
            ), */

              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: 70,
                      child: TextFormField(
                          controller: commentcontroller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Publish Goalsteps"),
                          style: TextStyle(
                              fontSize: 30.0,
                              height: 1.0,
                              color: Colors.white))),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ClipOval(
                      child: Material(
                        color: Colors.lightBlueAccent, // button color
                        child: InkWell(
                          splashColor: Colors.greenAccent, // inkwell color
                          child: SizedBox(
                              width: 64,
                              height: 64,
                              child: Icon(Icons.comment)),
                          onTap: () async {
                            await db
                                .collection('users')
                                .document(uid)
                                .updateData({'goal': goalstep});
                            await db
                                .collection('users')
                                .document(uid)
                                .updateData(
                                    {'comment': commentcontroller.text});
                            commentcontroller.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Friends(uid: uid),
                                ));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      )),
    );
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double totaldistance = 0;
  String distmp = '';
  Position start, dest;
  double distanceInMeters;
  /* void pos() async {
    start = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    timer = Timer.periodic(Duration(seconds: sec), (timer) {
      setState(() async {
        dest = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        distanceInMeters = _coordinateDistance(start.latitude, start.longitude,
                dest.latitude, dest.longitude) /
            1000;
        start = dest;
        totaldistance += (distanceInMeters / 1000);
        distmp = totaldistance.toStringAsFixed(2);
      });
    });
  } */

  void _startStopButtonPressed() {
    setState(() {
      goalstep = 0;
      gc = goalcontroller.text;
      //  pos();
      goalcontroller.clear();
      startflag = 1;
      if (_stopWatch.isRunning) {
        _buttonText = "Start";
        _stopWatch.stop();
      } else {
        _buttonText = "Stop";
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed() {
    setState(() {
      final Future<DocumentSnapshot> document =
          Firestore.instance.collection('users').document(uid).get();
      document.then<dynamic>((DocumentSnapshot snapshot) async {
        setState(() async {
          history = List.from(snapshot.data['history']);
        });
      });
      Map<String, dynamic> tmp = Map<String, dynamic>();
      setState(() {
        tmp['goal'] = goalstep;
        tmp['comment'] = comment;
      });
      DateTime now = DateTime.now();
      tmp['time'] = DateFormat.yMMMMd('en_US').format(now);
      history.add(tmp);
      db.collection('users').document(uid).updateData({'history': history});
      comment = '';
      //   timer.cancel();
      if (_stopWatch.isRunning) {
        _startStopButtonPressed();
      }
      totaldistance = 0;
      goalstep = 0;
      flag = 1;
      _percentage = 0;
      per = '0.0';
      sbcolor = Colors.green[400];
      goalcontroller.text = '';
      startflag = 0;
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
  }
}

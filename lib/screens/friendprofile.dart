import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steptracker/main.dart';
import 'findfriends.dart';

class FriendProfile extends StatefulWidget {
  final String name, friuid, currentuid;

  const FriendProfile({Key key, this.name, this.friuid, this.currentuid})
      : super(key: key);
  @override
  _FriendProfileState createState() =>
      _FriendProfileState(name, friuid, currentuid);
}

class _FriendProfileState extends State<FriendProfile> {
  final String name, friuid, currentuid;
  double height = 0, weight = 0, tmp = 1;
  String totalkm = '0', totalcal = '0', theight = '', tweight = '';
  int step;

  int buttonflag = 1, addflag = 1;
  // ignore: deprecated_member_use
  List<String> frilist = new List<String>();
  final db = Firestore.instance;
  _FriendProfileState(this.name, this.friuid, this.currentuid);

  Future<void> fridata() {
    final Future<DocumentSnapshot> document1 =
        Firestore.instance.collection('users').document(friuid).get();

    document1.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        step = await snapshot.data['steps'];
        theight = await snapshot.data['height'];
        tweight = await snapshot.data['weight'];
        height = double.parse(theight);
        weight = double.parse(tweight);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fridata();
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(currentuid).get();

    document.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        frilist = List.from(snapshot.data['friends']);

        for (int i = 0; i < frilist.length; i++) {
          if (frilist[i] == friuid) {
            setState(() {
              addflag = 0;
              buttonflag = 0;
            });
            break;
          }
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            fridata();

            setState(() {
              totalcal = ((step * weight * height * 25) / (1000 * 45 * 162.7))
                  .toStringAsFixed(2);
              totalkm = ((step * 0.73) / 1000).toStringAsFixed(2);
            });
          },
          backgroundColor: Colors.green,
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          )),
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text(name + "'s Profile"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          RaisedButton(
              child: Text(buttonflag == 0 ? 'FOLLOWING' : ' FOLLOW'),
              color: buttonflag == 0 ? Colors.green[500] : Colors.blue[700],
              onPressed: () async {
                if (addflag == 1)
                  frilist.add(friuid);
                else
                  frilist.remove(friuid);
                await db
                    .collection('users')
                    .document(currentuid)
                    .updateData({'friends': frilist});
                setState(() {
                  if (addflag == 0)
                    addflag = 1;
                  else
                    addflag = 0;

                  if (buttonflag == 0)
                    buttonflag = 1;
                  else
                    buttonflag = 0;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20),
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 490.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey[700],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 35, top: 7, bottom: 5, right: 30),
                      child: Image.asset(
                        'Assets/steps.webp',
                        height: 100,
                      ),
                    ),
                    Column(
                      children: [
                        Text('Total Steps',
                            style: GoogleFonts.kaushanScript(
                                fontSize: 25, color: Colors.white)),
                        gradientShaderMask3(
                          child: Text('$step',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 45)),
                        ),
                      ],
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
                width: 490.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey[700],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 35, top: 7, bottom: 5, right: 30),
                      child: Image.asset(
                        'Assets/Calories.png',
                        height: 100,
                      ),
                    ),
                    Column(
                      children: [
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
                width: 490.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey[700],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'Assets/road.png',
                        height: 100,
                      ),
                    ),
                    Column(
                      children: [
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

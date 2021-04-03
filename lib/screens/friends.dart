import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'findfriends.dart';
import 'friendprofile.dart';

class Friends extends StatefulWidget {
  final String uid;

  const Friends({Key key, this.uid}) : super(key: key);
  @override
  _FriendsState createState() => _FriendsState(uid);
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  final db = Firestore.instance;
  int userstep;
  String username, usercomment;
  //ScreenshotController screenshotController = ScreenshotController();
  String text = '';
  String subject = 'follow me';
  TabController tb;
  int rank, tmpflag = 1, tmprankflag = 1;
  List<DocumentSnapshot> documents, docs;
  File _imageFile;
  static GlobalKey previewContainer = new GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  // ignore: deprecated_member_use
  List<String> frilist = new List<String>();
  Map<String, int> friranks = new HashMap();
  Map<String, int> globalranks = new HashMap();
  final String uid;
  _FriendsState(this.uid);

  Future globaldata() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    documents = result.documents;
    documents.sort((a, b) => -a.data['goal'].compareTo(b.data['goal']));
    docs = documents;

    return documents;
  }

  Future friendsdata() async {
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(uid).get();
    document.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        frilist = List.from(snapshot.data['friends']);
      });
    });

    setState(() {
      for (int i = 0; i < docs.length; i++) {
        int f = 0;
        for (int j = 0; j < frilist.length; j++) {
          if (docs[i]['uid'] == frilist[j]) {
            f = 1;
            break;
          }
        }
        if (f == 0 && docs[i]['uid'] != uid) {
          docs.removeAt(i);
        }
      }
    });
    return docs;
  }

  @override
  void initState() {
    friendsdata();

    // TODO: implement initState
    super.initState();
    tb = TabController(length: 2, vsync: this);
  }

  Widget friends() {
    setState(() {
      globaldata();
    });
    return FutureBuilder(
        future: friendsdata(),
        builder: (context, snapshot) {
          rank = 0;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ));
          } else if (snapshot.data == null) {
            return Center(
              child: Text(
                "Press Refresh to Fetch List!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                int step = snapshot.data[i]['goal'];
                String name = snapshot.data[i]['name'];
                String comment = snapshot.data[i]['comment'] ?? '//';
                String id = snapshot.data[i]['uid'];
                Color cc = Colors.white24;
                if (id == uid) {
                  cc = Colors.greenAccent[200];
                } else {
                  cc = Colors.white24;
                }

                if (i == 0) {
                  rank = 1;
                } else {
                  if (snapshot.data[i]['goal'] != snapshot.data[i - 1]['goal'])
                    rank++;
                }

                friranks[id] = rank;
                return InkWell(
                  onTap: () {
                    if (snapshot.data[i]['uid'] != uid)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendProfile(
                                  name: name,
                                  friuid: snapshot.data[i]['uid'],
                                  currentuid: uid)));
                  },
                  child: Card(
                    elevation: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: cc, width: 2)),
                      child: Column(children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            Text(
                              '$name',
                              style: GoogleFonts.fjallaOne(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 230),
                          child: Text('Steps:$step',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.red[300],
                                fontSize: 15,
                              )),
                        ),
                        Text(
                          '$comment ',
                          style: GoogleFonts.pacifico(
                            color: Colors.orange[400],
                            fontSize: 20,
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              },
            );
          }
        });
  }

  Widget global() {
    return FutureBuilder(
        future: globaldata(),
        builder: (context, snapshot) {
          rank = 0;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                rank++;

                int step = snapshot.data[i]['goal'];
                String name = snapshot.data[i]['name'];
                String comment = snapshot.data[i]['comment'] ?? '//';
                String id = snapshot.data[i]['uid'];
                globalranks[id] = rank;

                Color cc = Colors.white24;
                if (id == uid) {
                  cc = Colors.greenAccent[200];
                } else {
                  cc = Colors.white24;
                }
                if (snapshot.data[i]['uid'] == uid) {
                  username = snapshot.data[i]['name'];
                  userstep = snapshot.data[i]['goal'];
                  usercomment = snapshot.data[i]['comment'];
                }

                return InkWell(
                  onTap: () {
                    if (snapshot.data[i]['uid'] != uid)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendProfile(
                                  name: name,
                                  friuid: snapshot.data[i]['uid'],
                                  currentuid: uid)));
                  },
                  child: Card(
                    elevation: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: cc, width: 2)),
                      child: Column(children: [
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            Text(
                              '$name',
                              style: GoogleFonts.fjallaOne(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 230),
                          child: Text('Steps:$step',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.red[300],
                                fontSize: 15,
                              )),
                        ),
                        Text(
                          '$comment ',
                          style: GoogleFonts.pacifico(
                            color: Colors.orange[400],
                            fontSize: 20,
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              },
            );
          }
        });
  }

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: TabBar(
              tabs: [
                Text(
                  'Global',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Friends',
                  style: TextStyle(fontSize: 30),
                )
              ],
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.yellow[300],
              controller: tb,
            ),
          ),
          body: RepaintBoundary(
            key: previewContainer,
            child: TabBarView(
              children: [global(), friends()],
              controller: tb,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 620, left: 120),
          child: Row(children: [
            FloatingActionButton(
              backgroundColor: Colors.green[500],
              onPressed: () {
                friendsdata();
                friendsdata();
                friendsdata();
                friendsdata();
              },
              child: Icon(Icons.refresh, color: Colors.white),
            ),
            SizedBox(width: 13),
            // ignore: deprecated_member_use
            FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.send_rounded, color: Colors.white),
              onPressed: () {
                text='Today\'s Goal\n🔸$username\n🔸Goalsteps:   $userstep Steps\n🔸Caption:   $usercomment\n\nBy Daily Step Tracker';
                final RenderBox box = context.findRenderObject();
                Share.share(text,
                    subject: subject,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              height: 45,
              // ignore: deprecated_member_use
              child: RaisedButton(
                  child: Text(
                    "Find Friends",
                    style: TextStyle(
                        color: Colors.blue[100],
                        fontSize: 17,
                        fontWeight: FontWeight.w900),
                  ),
                  color: Colors.blue[400],
                  splashColor: Colors.blue[900],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchBarDemoHome(uid: uid)));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            )
          ]),
        ),
      ],
    );
  }
}

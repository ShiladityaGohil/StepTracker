import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget {
  final String uid;

  const History({Key key, this.uid}) : super(key: key);
  @override
  _HistoryState createState() => _HistoryState(uid);
}

class _HistoryState extends State<History> {
  final String uid;
  String name;
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> history = new List<Map<String, dynamic>>();
  _HistoryState(this.uid);

  Future gethistory() {
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(uid).get();
    document.then<dynamic>((DocumentSnapshot snapshot) {
      setState(() {
        history = List.from(snapshot.data['history']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gethistory();
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(uid).get();
    document.then<dynamic>((DocumentSnapshot snapshot) {
      setState(() {
        history = List.from(snapshot.data['history']);
        print(history);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('History', style: TextStyle(fontSize: 20))),
        body: history != null
            ? ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.4)),
                      child: Column(children: [
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('Steps:${history[i]['goal']}',
                                  style: GoogleFonts.pressStart2p(
                                    color: Colors.red[300],
                                    fontSize: 15,
                                  )),
                            ),
                            SizedBox(width: 135),
                            Text(
                              '${history[i]['time'].toString().trim()}',
                              style: GoogleFonts.fjallaOne(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            
                          ],
                        ),
                        SizedBox(height:10),
                        Text(
                          '${history[i]['comment']}',
                          style: GoogleFonts.pacifico(
                            color: Colors.orange[400],
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height:10),

                      ]),
                    ),
                  );
                  /* Card(
              child: Column(children:[
                  Text('${history[i]['goal']}',style: TextStyle(color: Colors.white,fontSize: 20),),
                  Text('${history[i]['comment']}',style: TextStyle(color: Colors.white,fontSize: 20),),
                  Text('${history[i]['time']}',style: TextStyle(color: Colors.white,fontSize: 20)),
              ]),
            ); */
                },
              )
            : Container());
  }
}

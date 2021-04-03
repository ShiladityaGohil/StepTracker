import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steptracker/screens/addressdetail.dart';
import 'models/model.dart';
import 'package:photo_view/photo_view.dart';

class Coins extends StatefulWidget {
  final String uid;
  final String coins;

  const Coins({Key key, this.uid, this.coins}) : super(key: key);
  @override
  _CoinsState createState() => _CoinsState(uid,coins);
}

class _CoinsState extends State<Coins> {
  final String uid;
  String tmp = '';
  String coins = '',name;
  _CoinsState(this.uid,this.coins);

  Future getdata() async {
    final Future<DocumentSnapshot> document =
        Firestore.instance.collection('users').document(uid).get();
    await document.then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() async {
        coins = await snapshot.data['coins'];
        name=await snapshot.data['name'];
      });
    });
    return document;
  }

  @override
  void initState() {
    super.initState();
    coins;

  getdata();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          coins;
          coins;
          coins;
          coins;
          coins;
        });
        return getdata();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                '$coins  ',
                style: GoogleFonts.carterOne(color: Colors.green[300]),
              ),
              Text('ST Coins',
                  style: GoogleFonts.originalSurfer(color: Colors.orange[100])),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset('Assets/coin3.png'),
          ),
          actions: [],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => Card(
                    child:InkWell(
                      onTap: () {
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressDetail(
                                    index: index, uid: uid,name:name, coins: coins)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(140)),
                                height: 120,
                                child: Image.asset(products[index].image),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: Text(products[index].title,
                                  style: GoogleFonts.mcLaren(
                                    color: Colors.grey[400],
                                    fontSize: 17,
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image.asset('Assets/coin3.png',
                                      height: 35, width: 35),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, left: 5),
                                    child: Text(
                                      '${products[index].coins}',
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 25),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

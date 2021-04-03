
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  final FirebaseUser user;
  final String name, height, weight;
  const Profile({Key key, this.user, this.name, this.height, this.weight})
      : super(key: key);
  @override
  _ProfileState createState() => _ProfileState(user, name, height, weight);
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final db = Firestore.instance;
    String height, weight;
  bool _status = true;
  String email, name,url;
  TextEditingController nc = TextEditingController();
  TextEditingController hc = TextEditingController();
  TextEditingController wc = TextEditingController();
  TextEditingController ec = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  final FirebaseUser user;
  File _image;
  _ProfileState(this.user, this.name, this.height, this.weight);
  void initState() {
    // TODO: implement initState
    super.initState();
    nc.text = name;
    hc.text = height;
    wc.text = weight;
    ec.text = user.email;
  }
  /* void uploadImage() async {
    final StorageReference postImageRef = FirebaseStorage.instance
        .ref()
        .child('gs://complaint-box-f654a.appspot.com/');

    var timeKey = new DateTime.now();

    final StorageUploadTask uploadTask =
        postImageRef.child(timeKey.toString() + ".jpg").putFile(_image);

    var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = ImageUrl.toString();
  } */
  
  /*  Future getImage() async {
        // ignore: non_constant_identifier_names
    final image = await ImagePicker.pickImage(source:ImageSource.camera);
        setState(() {
          _image = image;
        });
       /*  PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800, 
    );*/
      }  */
      @override
      Widget build(BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 22.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: new Text('PROFILE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                    )),
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image:
                                          new ExactAssetImage('Assets/profile.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap:(){ },
                                    child: new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Parsonal Information',
                                      style: TextStyle(
                                          fontSize: 27.0,
                                          color: Colors.orange[300],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: nc,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Name",
                                    ),
                                    style: GoogleFonts.raleway(
                                      textStyle:
                                          Theme.of(context).textTheme.display2,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email ID',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    controller: ec,
                                    decoration: const InputDecoration(
                                      hintText: "Email Id",
                                    ),
                                    style: GoogleFonts.raleway(
                                      textStyle:
                                          Theme.of(context).textTheme.display2,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                    ),
                                    enabled: false,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Height (Cm)',
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 70.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Weight (Kg)',
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 40, left: 25),
                              child: Container(
                                width: 150,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: hc,
                                  decoration: const InputDecoration(
                                    hintText: "height",
                                  ),
                                  style: GoogleFonts.raleway(
                                    textStyle: Theme.of(context).textTheme.display2,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                width: 150,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: wc,
                                  decoration:
                                      const InputDecoration(hintText: "Weight"),
                                  style: GoogleFonts.raleway(
                                    textStyle: Theme.of(context).textTheme.display2,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                  ),
                                  enabled: !_status,
                                ),
                              ),
                            ),
                          ],
                        ),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    
      Widget _getActionButtons() {
        return Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                      height: 40,
                      child: new RaisedButton(
                        child: new Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          _status = true;
                          db.collection('users').document(user.uid).updateData({
                            'height': hc.text,
                            'name': nc.text,
                            'weight': wc.text
                          });
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                      )),
                ),
                flex: 2,
              ),
            ],
          ),
        );
      }
    
      Widget _getEditIcon() {
        return new GestureDetector(
            child: new CircleAvatar(
              backgroundColor: Colors.red,
              radius: 14.0,
              child: new Icon(
                Icons.edit,
                color: Colors.white,
                size: 16.0,
              ),
            ),
            onTap: () {
              setState(() {
                _status = false;
              });
            });
      }
    }
    
    class ImagePicker {
}

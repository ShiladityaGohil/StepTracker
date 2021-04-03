import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:photo_view/photo_view.dart';
import 'package:steptracker/main.dart';
import 'package:steptracker/screens/models/model.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddressDetail extends StatefulWidget {
  final String uid, name;
  final int index;
  final String coins;

  const AddressDetail({Key key, this.uid, this.index, this.coins, this.name})
      : super(key: key);
  @override
  _AddressDetailState createState() =>
      _AddressDetailState(index, uid, coins, name);
}

class _AddressDetailState extends State<AddressDetail> {
  String coins = '0.0';
  var message, smtpServer;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  final String uid, name;
  int itemcount = 0;
  String username;
  String e, m, a;

  final int index;
  _AddressDetailState(this.index, this.uid, this.coins, this.name);
  double dcoins;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    itemcount = 0;
    username = 'mgtemp53@gmail.com';
    String password = '9925433909mitul';

    // ignore: deprecated_member_use
    smtpServer = gmail(username, password);

    setState(() {
      coins;
      dcoins = double.parse(coins);
      e = emailcontroller.text;
      m = mobilecontroller.text;
      a = addresscontroller.text;
    });

    try {
      final sendReport = send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Details'),
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Homepage()));
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                  height: 200,
                  width: 500,
                  child: PhotoView(
                    customSize: MediaQuery.of(context).size,
                    imageProvider: AssetImage(products[index].image),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Container(
                  child: Text(
                    products[index].title,
                    style: GoogleFonts.acme(
                        fontSize: 30, color: Colors.orange[300]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('Assets/price.png')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Price: ',
                    style: GoogleFonts.carterOne(
                        color: Colors.grey[300], fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${products[index].coins}  ',
                    style: GoogleFonts.carterOne(
                        color: Colors.green[300], fontSize: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      child: Image.asset('Assets/coin3.png')),
                  Text(
                    '$coins  ',
                    style: GoogleFonts.carterOne(
                        color: Colors.green[300], fontSize: 20),
                  ),
                  Text('ST Coins',
                      style: GoogleFonts.originalSurfer(
                          color: Colors.orange[100], fontSize: 20)),
                ],
              ),
              Text(
                'Description:',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(height:10),
                Container(
                   decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(products[index].description,
                        style: GoogleFonts.prata(
                            color: Colors.white, fontSize: 18)),
                  ),
                ),
              
              SizedBox(height: 17),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 390,
                      child: TextFormField(
                        controller: emailcontroller,
                        cursorColor: Colors.white,
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Gmail"),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 390,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: mobilecontroller,
                        cursorColor: Colors.white,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required."),
                          MinLengthValidator(10,
                              errorText: "10 Digits Required."),
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Mobile No."),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 390,
                      child: TextFormField(
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: addresscontroller,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Address"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                  onPressed: () async {
                    if (formkey.currentState.validate()) {
                      formkey.currentState.save();
                      setState(() {
                        dcoins;
                        coins;
                      });
                      if (dcoins >= products[index].coins) {
                        dcoins -= products[index].coins;
                        coins = dcoins.toStringAsFixed(2);
                        Firestore.instance
                            .collection('users')
                            .document(uid)
                            .updateData({'coins': coins});
                        itemcount++;
                        Fluttertoast.showToast(
                            msg: itemcount == 1
                                ? "Purchased $itemcount item!"
                                : "Purchased $itemcount items!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red[300],
                            textColor: Colors.white,
                            fontSize: 16.0);

                        message = Message()
                          ..from = Address(username, 'StepTracker Team')
                          ..recipients.add('steptracker0@gmail.com')
                          /*   ..ccRecipients.addAll(
                          ['mitulgelani1@gmail.com', 'mitulgelani53@gmail.com']) */
                          // ..bccRecipients.add(Address('bccAddress@example.com'))
                          ..subject =
                              'StepTracker Orders:: 😀 :: ${DateTime.now()} $e'
                          ..html =
                              ' Customer Name: <h1> $name </h1> \n Email:   <h1> ${emailcontroller.text}</h1> \n Mobile No:  <h1> ${mobilecontroller.text} </h1>\n Address:  <h1>  ${addresscontroller.text}</h1>';

                        var connection = PersistentConnection(smtpServer);
                        await connection.send(message);
                        await connection.close();
                      } else {
                        Fluttertoast.showToast(
                            msg: "You don't have Enough Coins!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red[400],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                      print(
                          " Email: ${emailcontroller.text} \n Mobile No: ${mobilecontroller.text} \n Address: ${addresscontroller.text} ");
                    } else {
                      return null;
                    }
                  },
                  minWidth: 200,
                  height: 50,
                  color:Colors.amber[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38.0),
                  ),
                  child: Text(
                    "BUY NOW",
                    style: TextStyle(color: Colors.white,fontSize: 25),
                  )),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}

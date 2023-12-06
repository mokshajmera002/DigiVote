import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_digivote/Get_Manage_ID.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/result.dart';
import 'package:scan/scan.dart';
import 'package:new_digivote/widgets/themes.dart';

import 'Manage_Election.dart';

// MobileScannerController cameraController = MobileScannerController();

const bgcolor = Color(0xfffafafa);

class resultqrscannnerpage extends StatefulWidget {
  const resultqrscannnerpage({Key? key}) : super(key: key);

  @override
  State<resultqrscannnerpage> createState() => _resultqrscannnerpageState();
}

class _resultqrscannnerpageState extends State<resultqrscannnerpage> {
  // bool isScanCompleted=false;
  String qrcode = 'Unknown';
  String camqrcode = 'Unknown';
  String uid='';
  String admin_uid='';
  String user=FirebaseAuth.instance.currentUser!.uid;

  String getstatus='';
  String status='';


  // void closeScreen() {
  //   isScanCompleted=false;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<String> getDataFromDatabaseForResults(String ID) async {
    String answer="NA";
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
      print(snapshot.exists);
      if(snapshot.exists){
        // print("Yes");
        setState(() {
          status= snapshot.data()!['Status'];
          answer=status;
          // party= snapshot.data()!['Party'];
        });
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }else{
        answer="NE";
      }
    });
    return answer;
  }

  void exists(String ID) async {
    showStatusMessage("Inside exists", Colors.black);
    print("Inside Exists");
    // show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    },
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(ID).get();

    if ( snapshot.size == 0 ) {
      Navigator.pop(context);
      showStatusMessage("ID does not Exists.", Colors.orange);
      print('Collection does not exist');
    }else {
      Future<String> stringFuture = getDataFromDatabaseForResults(ID);
      // Navigator.pop(context);
      getstatus= await stringFuture;//getDataFromDatabase(ID).toString();
      if(getstatus=="Stop")
      {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => resultpage(ID: ID,flag: "1",))));
      }else{
        Navigator.pop(context);
        showStatusMessage("Result will get displayed once Voting is stopped.", Colors.pinkAccent);
      }
    }
  }

  void camera_exists(String ID) async {
    // showStatusMessage("Inside Cam exists", Colors.black);
    // print("Inside CamExists");
    // show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    },
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(ID).get();

    if ( snapshot.size == 0 ) {
      Navigator.pop(context);
      showStatusMessage("ID Does not Exists.", Colors.orange);
      // dispose();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => getmanageidpage(flag: "1",)));
      // Navigator.popUntil(context, (route) => false);
      dispose();
      // print('Collection does not exist');
    }else {
      Future<String> stringFuture = getDataFromDatabaseForResults(ID);
      // Navigator.pop(context);
      getstatus= await stringFuture;//getDataFromDatabase(ID).toString();
      if(getstatus=="Stop")
      {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => resultpage(ID: ID,flag: "1",))));
        dispose();
      }else{
        Navigator.pop(context);
        showStatusMessage("Result will get displayed once Voting is stopped.", Colors.pinkAccent);
        dispose();
      }
    }
  }

  Future<String> getDataFromDatabase(String ID) async {
    String answer='NA';
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
      print(snapshot.exists);
      if(snapshot.exists){
        print("Yes");
        // return snapshot.data()!['Admin_UID'];
        setState(() {
          print("StateState");
          uid= snapshot.data()!['Admin_UID'];
          // flag=1;
          // party= snapshot.data()!['Party'];
        });
        print("Setstate: "+uid);
        answer=uid;
        // return uid;
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }else{
        answer="NE";
      }
    });
    return answer;
    // Navigator.pop(context);
  }

  void scanfunction() async {
    List<Media>? res = await ImagesPicker.pick();
    if(res !=null)
    {
      String? str = await Scan.parse(res[0].path);
      if(str !=null)
      {
        // setState(() {
        qrcode=str;
        showStatusMessage(qrcode, Colors.green);
        exists(qrcode);
        // });
      }else {
        // qrcode="Not recognised";
        showStatusMessage("Image Not recognised", Colors.redAccent);
      }
    }
    else{
      // qrcode="Image not selected";
      showStatusMessage("Image not selected", Colors.redAccent);
    }
    // showStatusMessage(qrcode, Colors.green);
    qrcode="Unknown";
  }

  void showStatusMessage(String message,color)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      // duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    ); //showSnackBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: Text(
          "Scan QR",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mytheme.prim,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children:[
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text("Place the QR in the area."),
                    Text("Scanning will be started automatically."),
                    // ElevatedButton(onPressed: () {
                    //   Clipboard.set
                    // }, child: Text("Copy to Clipboard."))
                  ],
                ),
              ),
            ),
            Container(
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: Expanded(
                flex: 2,
                child: MobileScanner(
                  fit: BoxFit.fitHeight,
                  // controller: cameraController,
                  // allowDuplicates: true,
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    for (final barcode in barcodes) {
                      // showStatusMessage(barcode.rawValue.toString(), Colors.green);
                      print("QR Value: "+barcode.rawValue.toString());
                      if(await barcode.rawValue != null) {
                        // showStatusMessage("Before Exists", Colors.black);
                        // showStatusMessage(barcode.rawValue.toString(), Colors.green);
                        // dispose();
                        camqrcode=barcode.rawValue.toString();
                        // camera_exists(barcode.rawValue.toString());
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => manageelectionpage(ID: barcode.rawValue.toString())));
                        // dispose();
                      }
                      // debugPrint('Barcode found! ${barcode.rawValue}');
                    }
                    camera_exists(camqrcode);
                    // if(!isScanCompleted) {
                    //   String code
                    // }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    child: Text('QR Scan Image'),
                    onPressed: scanfunction
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


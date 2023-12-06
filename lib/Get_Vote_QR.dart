import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:scan/scan.dart';
import 'package:new_digivote/widgets/themes.dart';

// MobileScannerController cameraController = MobileScannerController();

const bgcolor = Color(0xfffafafa);

class qrscannnerpage extends StatefulWidget {
  const qrscannnerpage({Key? key}) : super(key: key);

  @override
  State<qrscannnerpage> createState() => _qrscannnerpageState();
}

class _qrscannnerpageState extends State<qrscannnerpage> {
  // bool isScanCompleted=false;
  String qrcode = 'Unknown';


  // void closeScreen() {
  //   isScanCompleted=false;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
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
                      showStatusMessage(barcode.rawValue.toString(), Colors.green);
                      if(await barcode.rawValue != null) {
                        // dispose();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                        dispose();
                      }
                      // debugPrint('Barcode found! ${barcode.rawValue}');
                    }
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


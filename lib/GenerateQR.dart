import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:new_digivote/widgets/themes.dart';

// String test;
class generateqrpage extends StatefulWidget {
  // final String ID;
  const generateqrpage({required this.ID});
  final String ID;

  @override
  State<StatefulWidget> createState() => generateqrpageState();
}

class generateqrpageState extends State<generateqrpage> {

  GlobalKey globalKey = new GlobalKey();
  // String _dataString = widget.ID;
  ScreenshotController screenshotController = ScreenshotController();

   void captureScreenshot() async {//made change in manifest and pinfo file
    // showStatusMessage("button pressed & function callled", Colors.black);
    RenderRepaintBoundary boundary=globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // showStatusMessage("Boundary:"+boundary.toString(), Colors.black);
    // if(boundary.debugNeedsPaint) {
    //   Timer(Duration(seconds: 1),() => captureScreenshot());
    // }
    ui.Image image=await boundary.toImage();
    // showStatusMessage("ui.Image:"+image.toString(), Colors.black);
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    // showStatusMessage("byteData:"+byteData.toString(), Colors.black);
    if(byteData != null){
      // Uint8List pngint8 = byteData.buffer.asUint8List();              //Uint8List.fromList(pngint8)
      final saveimage = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),quality: 90,name: 'election-id-${DateTime.now()}');  //'election-id-${DateTime.now()}.png'
      // print(saveimage);
      showStatusMessage(saveimage.toString(), Colors.blue);
    }else {
      showStatusMessage("Not saved", Colors.redAccent);
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    showStatusMessage(info, Colors.black);
  }

  void initState() {
    _requestPermission();
    super.initState();
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
     // test =widget.ID;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text('QR Code Generator',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: captureScreenshot,//_captureAndSharePng,
          )
        ],
      ),
      body: _contentWidget(),
    );
  }
  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Center(
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          color: Colors.white,
          child: QrImage(
            data: widget.ID,
            size: 320,//0.5 * bodyHeight,
            errorStateBuilder: (context, error) => Text("Error! Maybe your input value is too long?"),
          ),
        ),
      ),
    );
  }
}
// view rawflutter-qr-app-generate_screen.dart hosted with ❤ by GitHub
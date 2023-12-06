import 'dart:convert';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class newmatchpage extends StatefulWidget {
  @override
  _newmatchpageState createState() => _newmatchpageState();
}

class _newmatchpageState extends State<newmatchpage> {
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  var img1 = Image.asset('lib/assets/images/demo_profile.jpeg');
  var img2 = Image.asset('lib/assets/images/demo_profile.jpeg');
  String url='';
  Uint8List? image;
  String _similarity = "nil";
  String _liveness = "nil";
  double sim=0;

  Future getDataFromDatabase() async {
    await FirebaseFirestore.instance.collection("UNhjZAcu/election_admin/Candidates/").doc("BVhrLJp9h3lAM5iMERbN").get().then((snapshot) async {
      if(snapshot.exists) {
        url= snapshot.data()!['Profile URL'];
        //Get the image from the URL and then convert it to Uint8List
        Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url))
            .load(url))
            .buffer
            .asUint8List();
        setState(() {
          // url= snapshot.data()!['Profile URL'];
          setImage(
              true,
              bytes,
              Regula.ImageType.PRINTED);
          // img1=Image.network(url);
        });
        // flag=1;
        // initState();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getDataFromDatabase();
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      // var response = jsonDecode(event);
      // String transactionId = response["transactionId"];
      // bool success = response["success"];
      // print("video_encoder_completion:");
      // print("    success: $success");
      // print("    transactionId: $transactionId");
    });
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      // if (!response["success"]) {
      //   print("Init failed: ");
      //   print(json);
      // }
    });
  }

  // showAlertDialog(BuildContext context, bool first) => showDialog(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         AlertDialog(title: Text("Select option"), actions: [
  //           // ignore: deprecated_member_use
  //           TextButton(
  //               child: Text("Use gallery"),
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 ImagePicker()
  //                     .pickImage(source: ImageSource.gallery)
  //                     .then((value) => {
  //                   setImage(
  //                       first,
  //                       io.File(value!.path).readAsBytesSync(),
  //                       Regula.ImageType.PRINTED)
  //                 });
  //               }),
  //           // ignore: deprecated_member_use
  //           TextButton(
  //               child: Text("Use camera"),
  //               onPressed: () {
  //                 Regula.FaceSDK.presentFaceCaptureActivity().then((result) =>
  //                     setImage(
  //                         first,
  //                         base64Decode(Regula.FaceCaptureResponse.fromJson(
  //                             json.decode(result))!
  //                             .image!
  //                             .bitmap!
  //                             .replaceAll("\n", "")),
  //                         Regula.ImageType.LIVE));
  //                 Navigator.pop(context);
  //               })
  //         ]));

  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "nil");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(imageFile);
        image=imageFile;
        _liveness = "nil";
      });
    } else {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      setState(() => img2 = Image.memory(imageFile));
    }
  }

  // clearResults() {
  //   setState(() {
  //     img1 = Image.asset('assets/images/portrait.png');
  //     img2 = Image.asset('assets/images/portrait.png');
  //     _similarity = "nil";
  //     _liveness = "nil";
  //   });
  //   image1 = new Regula.MatchFacesImage();
  //   image2 = new Regula.MatchFacesImage();
  // }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => _similarity = "Processing...");
    var request = new Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        setState(() {
          _similarity = split!.matchedFaces.length > 0 ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +"%") : "error";
          if(split.matchedFaces.length > 0)
          {
            sim=split.matchedFaces[0]!.similarity! * 100;
          }else {
            sim=0;
          }
          print(sim.toString());
        });

      });
    });
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    setImage(false, base64Decode(result!.bitmap!.replaceAll("\n", "")),
        Regula.ImageType.LIVE);
    setState(() => _liveness =
    result.liveness == Regula.LivenessStatus.PASSED
        ? "passed"
        : "unknown");
  });

  Vote(sim) {
    if(sim>90.0)
      {
        print("Proccedd to Vote");
      }else{
      print("Fail to Vote");
    }
  }

  // uploadImage(Uint8List? image) async{
  //   String unique=randomAlphaNumeric(16);
  //   //get a reference to storage root
  //   Reference referenceRoot=FirebaseStorage.instance.ref();
  //   Reference referenceDirImages=referenceRoot.child('candidate_auth');
  //
  //   //create a reference for img to be stored
  //   Reference referenceImageToUpload=referenceDirImages.child(unique);
  //
  //   //store the file
  //   if(image!=null){
  //     await referenceImageToUpload.putData(image).then((p0) {
  //       //   imgURL= await referenceImageToUpload.getDownloadURL();
  //       print("Success");
  //     });
  //   }
  //
  //   //     .putFile(File(path)).then((p0) async{
  //   //   imgURL= await referenceImageToUpload.getDownloadURL();
  //   //   addUserDetails(ID,imgURL, name, party, position, count);
  //   // }).onError((error, stackTrace) {
  //   //   Navigator.pop(context);
  //   //   showStatusMessage(error.toString(), Colors.redAccent);
  //   // });
  //
  // }

  Widget createButton(String text, VoidCallback onPress) => Container(
    // ignore: deprecated_member_use
    child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
        ),
        onPressed: onPress,
        child: Text(text)),
    width: 250,
  );

  Widget createImage(image) => Material(
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(height: 150, width: 150, image: image),
        ),
      ));

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createImage(img1.image),
              createImage(img2.image),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
              createButton("Match", () => matchFaces()),
              createButton("Liveness", () => liveness()),
              createButton("Vote", () => Vote(sim)),
              // createButton("Upload", () => uploadImage(image)),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Similarity: " + _similarity,
                          style: TextStyle(fontSize: 18)),
                      Container(margin: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                      Text("Liveness: " + _liveness,
                          style: TextStyle(fontSize: 18))
                    ],
                  ))
            ])),
  );
}

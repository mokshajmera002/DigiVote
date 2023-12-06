import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_digivote/Face.dart';
import 'package:new_digivote/RecyclerTest.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/new_face.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:random_string/random_string.dart';

class finalfacepage extends StatefulWidget {
  const finalfacepage({Key? key}) : super(key: key);

  @override
  State<finalfacepage> createState() => _finalfacepageState();
}

class _finalfacepageState extends State<finalfacepage> {
  // String random=randomAlphaNumeric(8);
  // final user=FirebaseAuth.instance.currentUser!;
  // String? id='';
  int flag=0;
  String path="lib/assets/images/demo_profile.jpeg";
  Uint8List image=Uint8List.fromList([]);
  // late String id;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
      // var response = jsonDecode(json);
      // if (!response["success"]) {
      //   print("Init failed: ");
      //   print(json);
      // }
    });
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    setState(() {
      image=base64Decode(result!.bitmap!.replaceAll("\n", ""));
      flag=1;
    });
    // setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),Regula.ImageType.LIVE);
    // setState(() => _liveness =
    // result.liveness == Regula.LivenessStatus.PASSED
    //     ? "passed"
    //     : "unknown");
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Mock Face Page"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("LOGGED IN AS: " + user.email!),
              // Text("Data: "+id!),
              // ElevatedButton(
              //     child: Text('Recycler Page'),
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => recyclerlist()));
              //     }
              // ),
              // ElevatedButton(
              //     child: Text('Face Page'),
              //     onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => newfacepage()));
              //     }
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Stack(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      shape: CircleBorder(
                        // eccentricity: 0.2,
                          side: BorderSide(
                              color: Colors.black, width: 2)),
                      child: CircleAvatar(
                        backgroundImage: (flag==0)?AssetImage(path):MemoryImage(image) as ImageProvider,//Image.asset(path).image,//Image.file(File(path)).image,//AssetImage(
                        // path), //"lib/assets/images/demo_profile.jpeg"
                        radius: 100,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 25,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: mytheme.prim),
                        child: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            liveness();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

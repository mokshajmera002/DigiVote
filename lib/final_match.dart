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

class finalmatchpage extends StatefulWidget {
  const finalmatchpage({Key? key}) : super(key: key);

  @override
  State<finalmatchpage> createState() => _finalmatchpageState();
}

class _finalmatchpageState extends State<finalmatchpage> {
  // String random=randomAlphaNumeric(8);
  // final user=FirebaseAuth.instance.currentUser!;
  // String? id='';
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  int flag=0;
  String path="lib/assets/images/demo_profile.jpeg";
  String url='';
  Uint8List image=Uint8List.fromList([]);
  String _similarity = "nil";
  String _liveness = "nil";
  double sim=0;

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
      // var response = jsonDecode(json);
      // if (!response["success"]) {
      //   print("Init failed: ");
      //   print(json);
      // }
    });
  }

  Future getDataFromDatabase() async {
    print("inside getdata");
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
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
          setVariable(true,bytes,Regula.ImageType.PRINTED);
          // img1=Image.network(url);
        });
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }
    });
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
    var result = Regula.LivenessResponse.fromJson(json.decode(value));
    setState(() {
      image=base64Decode(result!.bitmap!.replaceAll("\n", ""));
      setVariable(false, base64Decode(result.bitmap!.replaceAll("\n", "")),Regula.ImageType.LIVE);
      flag=1;
    });
    // setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),Regula.ImageType.LIVE);
    // setState(() => _liveness =
    // result.liveness == Regula.LivenessStatus.PASSED
    //     ? "passed"
    //     : "unknown");
  });

  setVariable(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "nil");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        // img1 = Image.memory(imageFile);
        // image=imageFile;
        _liveness = "nil";
      });
    } else {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      // setState(() => img2 = Image.memory(imageFile));
    }
  }

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

  Vote(sim) {
    if(sim>90.0)
    {
      print("Proccedd to Vote");
    }else{
      print("Fail to Vote");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Mock Match Face Page"),
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
                  )
              ),
              ElevatedButton(
                  child: Text('Match'),
                  onPressed: () {
                    matchFaces();
                  }
              ),
              ElevatedButton(
                  child: Text('Vote'),
                  onPressed: () {
                    Vote(sim);
                  }
              ),
            ],
          )
      ),
    );
  }
}

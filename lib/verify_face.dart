import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_digivote/Face.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/RecyclerTest.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/new_face.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:random_string/random_string.dart';

class verifyfacepage extends StatefulWidget {
  const verifyfacepage({Key? key,required this.ID,required this.docID,required this.count,required this.name,required this.email,required this.finish,required this.voter_profile_url}) : super(key: key);
  final String ID;
  final String docID;
  final String count;
  final String name;
  final String email;
  final String finish;
  final String voter_profile_url;

  @override
  State<verifyfacepage> createState() => _verifyfacepageState();
}

class _verifyfacepageState extends State<verifyfacepage> {
  String new_ID='';
  String new_docID='';
  String new_count='';
  String new_name='';
  String new_email='';
  String new_finish='';
  String new_voter_profile_url='';
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
    });
  }

  Future getDataFromDatabase() async {
    // print("inside getdata");
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot) async {
      if(snapshot.exists) {
        url= snapshot.data()!['Face URL'];
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
        showStatusMessage("Image loaded", Colors.lightGreen);
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

  Vote(sim,ID,docID,count,name,email,finish,voter_profile_url) {
    if(sim>90.0)
    {
      addUserDetails(ID, docID, count, name, email, finish,voter_profile_url);
    }else{
      showStatusMessage("Face does not match.", Colors.redAccent);
    }
  }

  void addUserDetails(String ID,String docID,String count,String name,String email,String finish,String voter_profile_url) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection('$ID/election_voted/Voters').doc(FirebaseAuth.instance.currentUser?.uid).set(   //map means the brackets for .add see mitch koko video for reference
        {
          'Name' : name,
          'E-Mail': email,
          'Finish': finish,
          'Profile URL': voter_profile_url,
        }).then((value) {
      Navigator.pop(context);
      updateCount(ID, docID, count);
    });
    // final userData = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); //if no name in doc() is given then automatically id will get generated
    // and we can access it by using userData.id
    // final json={
    //   'E-Mail': email,
    //   'National ID':nationalid,
    // };
    // await userData.set(json);
  }

  void updateCount(String ID,String doc,String count) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
      'Count': count,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      // updatecount=true;
      showStatusMessage("Voted Successfully.", Colors.green);
      // getDataFromDatabase(ID, doc);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
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
    new_ID=widget.ID;
    new_docID=widget.docID;
    new_count=widget.count;
    new_name=widget.name;
    new_email=widget.email;
    new_finish=widget.finish;
    new_voter_profile_url=widget.voter_profile_url;
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Face",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: mytheme.prim,
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
                    Vote(sim, new_ID, new_docID, new_count, new_name, new_email, new_finish,new_voter_profile_url);
                  }
              ),
            ],
          )
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_digivote/Face.dart';
import 'package:new_digivote/RecyclerTest.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/new_face.dart';
import 'package:new_digivote/verify.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:random_string/random_string.dart';

class signupfacepage extends StatefulWidget {
  const signupfacepage({Key? key,required this.email,required this.password,required this.username,required this.usernationalID,required this.userphno,required this.profilepath}) : super(key: key);
  final String email;
  final String password;
  final String username;
  final String usernationalID;
  final String userphno;
  final String profilepath;

  @override
  State<signupfacepage> createState() => _signupfacepageState();
}

class _signupfacepageState extends State<signupfacepage> {
  // String random=randomAlphaNumeric(8);
  // final user=FirebaseAuth.instance.currentUser!;
  // String? id='';
  String new_email='';
  String new_password='';
  String new_username='';
  String new_usernationalID='';
  String new_userphno='';
  String new_profilepath='';
  String profile_url='';
  String face_url='';
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

  uploadImage(Uint8List? image,String email,String name,String nationalid,String phno,String profile_url) async{
    // String unique=randomAlphaNumeric(16);
    //get a reference to storage root
    Reference referenceRoot=FirebaseStorage.instance.ref();
    Reference referenceDirImages=referenceRoot.child('user_auth');

    //create a reference for img to be stored
    // user=FirebaseAuth.instance.currentUser!;
    Reference referenceImageToUpload=referenceDirImages.child(FirebaseAuth.instance.currentUser!.uid);

    //store the file
    if(image!=null){
      await referenceImageToUpload.putData(image).then((p0) async{
          face_url= await referenceImageToUpload.getDownloadURL();
          addUserDetails(email, name, nationalid, phno,profile_url,face_url);
        // print("Success");
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        showStatusMessage(error.toString(), Colors.redAccent);
      });
    }

    //     .putFile(File(path)).then((p0) async{
    //   imgURL= await referenceImageToUpload.getDownloadURL();
    //   addUserDetails(ID,imgURL, name, party, position, count);
    // }).onError((error, stackTrace) {
    //   Navigator.pop(context);
    //   showStatusMessage(error.toString(), Colors.redAccent);
    // });

  }

  void addProfileImage(String path,Uint8List? image,String email,String name,String nationalid,String phno) async{
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
    // String unique=randomAlphaNumeric(16);
    //get a reference to storage root
    Reference referenceRoot=FirebaseStorage.instance.ref();
    Reference referenceDirImages=referenceRoot.child('user_img');

    //create a reference for img to be stored
    Reference referenceImageToUpload=referenceDirImages.child(FirebaseAuth.instance.currentUser!.uid);

    //store the file
    await referenceImageToUpload.putFile(File(path)).then((p0) async{
      profile_url= await referenceImageToUpload.getDownloadURL();
      uploadImage(image, email, name, nationalid, phno,profile_url);
      // addUserDetails(ID,imgURL, name, party, position, count);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.redAccent);
    });

  }

  void signUserUp(email,password,name,nationalid,phno,profile_path,Uint8List? image) async
  {
    // if(nationalId.text != '' && passwordController.text != '' && emailController.text != '')
    // {
      //show loading circle
      showDialog(context: context, builder: (context)
      {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      );

      // if(passwordController.text!=confirmpasswordController.text )
      // {
      //   Navigator.pop(context);
      //   showStatusMessage("Passwords don't match.",Colors.red);
      //   return;
      // }

      //try creating the user
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
          addProfileImage(profile_path, image, email, name, nationalid, phno);
          // uploadImage(image);
          // addUserDetails(email,name,nationalID,phno);
          //pop the loading circle
          // Navigator.pop(context);
          // showStatusMessage("Account Created Successfully and email sent.",Colors.green);
        });

        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => verifypage())));
        // Navigator.pop(context);


      }on FirebaseAuthException catch(e)
      {
        if(e.code=='invalid-email')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Invalid E-mail.',Colors.red);
        }else if(e.code=='unknown')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Kindly Fill all the Fields.',Colors.red);
        }else if(e.code=='weak-password')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Kindly make strong password.',Colors.red);
        }else if(e.code=='email-already-in-use')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Account already Exists.',Colors.greenAccent);
        }else {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage(e.code, Colors.red);
        }
      }
    // }
    // else{
    //   showStatusMessage('Kindly fill all fields.', Colors.deepOrangeAccent);
    // }
  }

  void addUserDetails(String email,String name,String nationalid,String phno,String profile_url,String face_url) async {
    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).set(   //map means the brackets for .add see mitch koko video for reference
        {
          'E-Mail': email,
          'Name': name,
          'National ID':nationalid,
          'Phone Number':phno,
          'Profile URL':profile_url,
          'Face URL':face_url,
        }).then((value) {
          Navigator.pop(context);
          showStatusMessage("Account Created Successfully and email sent.",Colors.green);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => verifypage())));
        });
    // final userData = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); //if no name in doc() is given then automatically id will get generated
    // and we can access it by using userData.id
    // final json={
    //   'E-Mail': email,
    //   'National ID':nationalid,
    // };
    // await userData.set(json);
  }

  //shows status in snackbar
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
    new_email=widget.email;
    new_password=widget.password;
    new_username=widget.username;
    new_usernationalID=widget.usernationalID;
    new_userphno=widget.userphno;
    new_profilepath=widget.profilepath;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Face Auth Register Page",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
              ElevatedButton(
                  child: Text('Create Account'),
                  onPressed: () {
                    if(flag>0)
                      {
                        signUserUp(new_email, new_password, new_username, new_usernationalID, new_userphno, new_profilepath, image);
                      }
                  }
              ),
            ],
          )
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:new_digivote/Manage_Election.dart';
import 'package:new_digivote/signup_auth_page.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:random_string/random_string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';


class signupprsnlpage extends StatefulWidget {
  const signupprsnlpage({Key? key, required this.email,required this.password}) : super(key: key);
  final String email;
  final String password;

  @override
  State<signupprsnlpage> createState() => signupprsnlpageState();
}

class signupprsnlpageState extends State<signupprsnlpage> {

  // int flag=0;
  // String? id='';
  final username=TextEditingController();
  final usernationalID=TextEditingController();
  final userphno=TextEditingController();
  String new_email='';
  String new_password='';
  String path="lib/assets/images/demo_profile.jpeg"; //"lib/assets/images/demo_profile.jpeg"
  String imgURL='';
  int flag=0;

  // void initState() {
  //   getDataFromDatabase();
  // }
  void dispose() {
    username.dispose();
    usernationalID.dispose();
    userphno.dispose();
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

  // void addImage(String path,String ID,String name,String party,String position,String count) async{
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   String unique=randomAlphaNumeric(16);
  //   //get a reference to storage root
  //   Reference referenceRoot=FirebaseStorage.instance.ref();
  //   Reference referenceDirImages=referenceRoot.child('candidate_img');
  //
  //   //create a reference for img to be stored
  //   Reference referenceImageToUpload=referenceDirImages.child(unique);
  //
  //   //store the file
  //   await referenceImageToUpload.putFile(File(path)).then((p0) async{
  //     imgURL= await referenceImageToUpload.getDownloadURL();
  //     addUserDetails(ID,imgURL, name, party, position, count);
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.redAccent);
  //   });
  //
  // }
  //
  // void addUserDetails(String ID,String URL,String name,String party,String position,String count) async {
  //   // showDialog(context: context, builder: (context)
  //   // {
  //   //   return const Center(
  //   //     child: CircularProgressIndicator(),
  //   //   );
  //   // },
  //   // );
  //   await FirebaseFirestore.instance.collection('$ID/election_admin/Candidates').doc().set(   //map means the brackets for .add see mitch koko video for reference
  //       {
  //         'Profile URL': URL,
  //         'Name': name,
  //         'Party':party,
  //         'Position': position,
  //         'Count':count,
  //       }).then((value) {
  //     Navigator.pop(context);
  //     showStatusMessage("Candidate Created Successfully", Colors.green);
  //     // initState();
  //     // dispose();
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.red);
  //   });
  // }

  void getImageFromCamera() async{
    List<Media>? res=await ImagesPicker.openCamera(
      pickType: PickType.image,
      cropOpt: CropOption(cropType: CropType.circle),
    );
    if(res!=null){
      setState(() {
        path=res[0].path;
        print(path);
        flag=1;
      });
    }else{
      showStatusMessage("Image not Captured.", Colors.brown);
    }
  }

  void getImageFromGallery() async{
    List<Media>? res=await ImagesPicker.pick(
      pickType: PickType.image,
      count: 1,
      cropOpt: CropOption(cropType: CropType.circle),
    );
    if(res!=null){
      setState(() {
        path=res[0].path;
        print(path);
        flag=1;
      });
    }else{
      showStatusMessage("Gallery Image not Captured.", Colors.brown);
    }
  }

  @override
  Widget build(BuildContext context) {
    new_email=widget.email;
    new_password=widget.password;
    print(new_email);
    print(new_password);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Personal Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: (){
          // print("email"+new_email);
          // print("pass1"+new_password);
          // print("usname"+username.text);
          // print("natid"+usernationalID.text);
          // print("path"+path);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => signupfacepage(email: new_email, password: new_password, username: username.text, usernationalID: usernationalID.text, userphno: userphno.text, profilepath: path)));
        },
        backgroundColor: mytheme.prim,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 5),
              child: Center(
                child: Text(
                  "Personal Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Center(
                child: Text(
                  "Add new your personal details below.",
                  style: TextStyle(color: Vx.gray500, fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 530,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
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
                                backgroundImage: (flag==0)?AssetImage(path):Image.file(File(path)).image,//Image.asset(path).image,//Image.file(File(path)).image,//AssetImage(
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
                                  onPressed: () async {
                                    return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Container(
                                              height: 200,
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Column(
                                                  children: [
                                                    Text("Select Image From...."),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                              getImageFromCamera();
                                                              print("From Camera");
                                                            }, icon: Icon(Icons.camera_alt)),
                                                            Text("From Camera")
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                              getImageFromGallery();
                                                              print("From Gallery");
                                                            }, icon: Icon(Icons.file_upload)),
                                                            Text("From Gallery")
                                                          ],
                                                        ),

                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // children: [
                                            //   Column(
                                            //     children: [
                                            //       IconButton(onPressed: (){
                                            //         print("From Camera");
                                            //       }, icon: Icon(Icons.camera_alt)),
                                            //       Text("From Camera")
                                            //     ],
                                            //   ),
                                            //   Column(
                                            //     children: [
                                            //       IconButton(onPressed: (){
                                            //         print("From Gallery");
                                            //       }, icon: Icon(Icons.file_upload)),
                                            //       Text("From Gallery")
                                            //     ],
                                            //   )
                                            // ],
                                            // child: Row(
                                            //   children: [
                                            //     Column(
                                            //       children: [
                                            //         IconButton(onPressed: (){
                                            //           print("From Camera");
                                            //         }, icon: Icon(Icons.camera_alt)),
                                            //         Text("From Camera")
                                            //       ],
                                            //     ),
                                            //     Column(
                                            //       children: [
                                            //         IconButton(onPressed: (){
                                            //           print("From Gallery");
                                            //         }, icon: Icon(Icons.file_upload)),
                                            //         Text("From Gallery")
                                            //       ],
                                            //     )
                                            //   ],
                                            // ),
                                          );
                                        }
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: TextFormField(
                          controller: username,

                          decoration: InputDecoration(
                            // labelText: "Username",
                            labelStyle: TextStyle(color: mytheme.prim),
                            focusedBorder: OutlineInputBorder(
                              // borderSide:
                              //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                borderSide: BorderSide(color: mytheme.prim),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            prefixIcon: Icon(
                              Icons.person,
                              color: mytheme.prim,
                            ),
                            hintText: "Enter Your Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: TextFormField(
                          controller: usernationalID,
                          decoration: InputDecoration(
                            // labelText: "Username",
                            labelStyle: TextStyle(color: mytheme.prim),
                            focusedBorder: OutlineInputBorder(
                              // borderSide:
                              //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                borderSide: BorderSide(color: mytheme.prim),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            prefixIcon: Icon(
                              Icons.group,
                              color: mytheme.prim,
                            ),
                            hintText: "Enter your NationalID",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: TextFormField(
                          controller: userphno,
                          decoration: InputDecoration(
                            // labelText: "Username",
                            labelStyle: TextStyle(color: mytheme.prim),
                            focusedBorder: OutlineInputBorder(
                              // borderSide:
                              //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                borderSide: BorderSide(color: mytheme.prim),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                            prefixIcon: Icon(
                              Icons.label_outline,
                              color: mytheme.prim,
                            ),
                            hintText: "Enter your Phonenumber",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                      //   child: Center(
                      //     child: ElevatedButton(
                      //         style: ElevatedButton.styleFrom(
                      //           minimumSize: Size(1000, 50),
                      //           backgroundColor: mytheme.prim,
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(15)),
                      //           shadowColor: Colors.black,
                      //           // overlayColor:
                      //           //     MaterialStateColor.resolveWith((states) => Colors.cyan),
                      //         ),
                      //         onPressed: () {
                      //           if(flag==1){
                      //             addImage(path, new_ID, candidatename.text.trim(), candidateparty.text.trim(), candidateposition.text.trim(), "0");
                      //           }else{
                      //             showStatusMessage("Kindly upload an Image.", Colors.pinkAccent);
                      //           }
                      //           // addImage(path, new_ID, candidatename.text.trim(), candidateparty.text.trim(), candidateposition.text.trim(), "0");
                      //           // addUserDetails(new_ID, candidatename.text.trim(), candidateparty.text.trim(), candidateposition.text.trim(), "0");
                      //           // Navigator.push(
                      //           //     context,
                      //           //     MaterialPageRoute(
                      //           //         builder: (context) => tile()));
                      //         },
                      //         child: Text(
                      //           "Create",
                      //           style: TextStyle(
                      //             fontSize: 20,
                      //             color: Colors.black,
                      //             backgroundColor: Colors.transparent,
                      //           ),
                      //         )),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

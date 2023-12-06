import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:new_digivote/Manage_Election.dart';
import 'package:new_digivote/widgets/themes.dart';


class profilepage extends StatefulWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  final String user_uid=FirebaseAuth.instance.currentUser!.uid;

  int flag=0;
  // String? id='';
  String username='Loading..';
  String usernationalID='Loading..';
  String userphno='Loading..';
  // String new_ID='';
  // String new_docID='';
  String URL='';
  String path='';
  String imageURL='';

  final usernameController=TextEditingController();
  final usernationalIDController=TextEditingController();
  final userphnoController=TextEditingController();

  // void initState() {
  //   super.initState();
  //   getDataFromDatabase(new_ID,new_docID);
  // }

  // void loading() {
  //   //show loading circle
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   getDataFromDatabase();
  //   //pop the loading circle
  //   Navigator.pop(context);
  //   showStatusMessage("Data fetched.",Colors.green);
  // }

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

  Future getDataFromDatabase() async {
    await FirebaseFirestore.instance.collection("Users").doc(user_uid).get().then((snapshot) {
      if(snapshot.exists){
        setState(() {
          username= snapshot.data()!['Name'];
          usernationalID= snapshot.data()!['National ID'];
          userphno= snapshot.data()!['Phone Number'];
          URL=snapshot.data()!['Profile URL'];
        });
        flag=1;
        // initState();
      }
    });
  }

  void updateUserName(String name) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("Users").doc(user_uid).update({
      'Name': name,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("Name updated Successfully.", Colors.green);
      getDataFromDatabase();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  void updateUserNationalID(String nationalID) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("Users").doc(user_uid).update({
      'National ID': nationalID,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("National ID updated Successfully.", Colors.green);
      getDataFromDatabase();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  void updateUserPhno(String phno) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("Users").doc(user_uid).update({
      'Phone Number': phno,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("Phone-Number updated Successfully.", Colors.green);
      getDataFromDatabase();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  void getImageFromCamera(String URL) async{
    List<Media>? res=await ImagesPicker.openCamera(
      pickType: PickType.image,
      cropOpt: CropOption(cropType: CropType.circle),
    );
    if(res!=null){
      setState(() {
        path=res[0].path;
        print(path);
        // flag=1;
      });
      editImage(URL, path);
    }else{
      showStatusMessage("Image not Captured.", Colors.brown);
    }
  }

  void getImageFromGallery(String URL) async{
    List<Media>? res=await ImagesPicker.pick(
      pickType: PickType.image,
      count: 1,
      cropOpt: CropOption(cropType: CropType.circle),
    );
    if(res!=null){
      setState(() {
        path=res[0].path;
        print(path);
        // flag=1;
      });
      editImage(URL, path);
    }else{
      showStatusMessage("Gallery Image not Captured.", Colors.brown);
    }
  }

  void editImage(String URL,String path) async{
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    Reference referenceImageToUpload=FirebaseStorage.instance.refFromURL(URL);
    await referenceImageToUpload.putFile(File(path)).then((p0) async{
      imageURL=await referenceImageToUpload.getDownloadURL();
      updateURL(imageURL);
    }).onError((error, stackTrace) {
      showStatusMessage(error.toString(), Colors.redAccent);
    });

  }

  void updateURL(String URL) async {
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection("Users").doc(user_uid).update({
      'Profile URL': URL,
    }).then((value) {
      Navigator.pop(context);
      showStatusMessage("Image updated Successfully.", Colors.green);
      getDataFromDatabase();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  // void deleteCandidate(String ID,String doc,String URL) async{
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   await FirebaseStorage.instance.refFromURL(URL).delete().then((value) async{
  //     await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).delete().then((value) {
  //       Navigator.pop(context);
  //       showStatusMessage("Candidate Deleted Successfully.", Colors.lightGreen);
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: ID, flag: "0")));
  //     }).onError((error, stackTrace) {
  //       Navigator.pop(context);
  //       showStatusMessage(error.toString(), Colors.redAccent);
  //     });
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.redAccent);
  //   });
  // }

  // Future<void> _showAlertDialog(String ID,String doc) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('DigiVote',style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //           ),
  //           content: Text('Are you sure you want to delete this candidate?'),
  //           actions: [
  //             TextButton(onPressed: () {
  //               Navigator.of(context).pop(false);
  //             }, child: Text('No')),
  //             TextButton(onPressed: () {
  //               // test=signUserOut();
  //               Navigator.of(context).pop(true);
  //               deleteCandidate(ID, doc,URL);
  //             }, child: Text(
  //               'Yes',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w900,
  //                 // color: Colors.green,
  //                 // fontSize: 35,
  //               ),
  //             ),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }

  // void showAlertDialog(BuildContext context){
  //   Widget Save= E
  // }

  // new_ID=widget.ID;
  // new_docID=widget.docID;
  // // print(new_ID);
  // if(flag==0)
  // {
  // print("getdata");
  // getDataFromDatabase(new_ID,new_docID);
  // }else{
  // print("moksh");
  // }
  //
  // // getDataFromDatabase();
  // print(new_ID);
  // flag=1;

  @override
  Widget build(BuildContext context) {
    // print(new_ID);
    if(flag==0)
    {
      print("getdata");
      getDataFromDatabase();
    }else{
      print("moksh");
    }

    // getDataFromDatabase();
    // print(new_ID);
    flag=1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "User Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         _showAlertDialog(new_ID, new_docID);
        //       }
        //       , icon: Icon(Icons.delete_sharp,color: Colors.black,)
        //   ) //power_settings_new_rounded
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
              child: Stack(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(
                      // eccentricity: 0.2,
                        side: BorderSide(color: Colors.black, width: 2)),
                    child: CircleAvatar(
                      backgroundImage:
                      Image.network(URL).image,
                      //AssetImage("lib/assets/images/demo_profile.jpeg"),
                      radius: 90,
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
                                                    getImageFromCamera(URL);
                                                    print("From Camera");
                                                  }, icon: Icon(Icons.camera_alt)),
                                                  Text("From Camera")
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(onPressed: (){
                                                    Navigator.pop(context);
                                                    getImageFromGallery(URL);
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
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(username,
                    // "Raj Ganatra",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      usernameController.text=username;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter new name',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: name,
                                ),
                                // initialValue: name,
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updateUserName(usernameController.text.trim());
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    // color: Colors.green,
                                    // fontSize: 35,
                                  ),
                                ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ListTile(
                leading: Icon(Icons.group),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "National ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(usernationalID,
                    // "BJP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      usernationalIDController.text=usernationalID;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter new national ID',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: usernationalIDController,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: party,
                                ),
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updateUserNationalID(usernationalIDController.text.trim());
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    // color: Colors.green,
                                    // fontSize: 35,
                                  ),
                                ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ListTile(
                leading: Icon(Icons.label_outline),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(userphno,
                    // "Persident",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      userphnoController.text=userphno;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(

                              title: Text('Enter new phone number',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: userphnoController,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: position,
                                ),
                                keyboardType: TextInputType.number,
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updateUserPhno(userphnoController.text.trim());
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    // color: Colors.green,
                                    // fontSize: 35,
                                  ),
                                ),
                                ),
                              ],
                            );
                          });
                    },
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

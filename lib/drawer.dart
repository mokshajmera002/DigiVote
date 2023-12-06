// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/login.dart';
import 'package:new_digivote/profile.dart';
import 'package:new_digivote/test.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';

class drawerpage extends StatefulWidget {
  const drawerpage({required this.name,required this.profile_url});
  final String name;
  final String profile_url;

  @override
  State<drawerpage> createState() => _drawerpageState();
}

class _drawerpageState extends State<drawerpage> {
  final user=FirebaseAuth.instance.currentUser!;
  String g_name='Loading...';
  String path='lib/assets/images/demo_profile.jpeg';
  int flag=0;

  // Future<void> share() async {
  //   await FlutterShare.share(
  //       title: 'Example share',
  //       text: 'Example share text',
  //       linkUrl: 'https://flutter.dev/',
  //       chooserTitle: 'Example Chooser Title');
  // }

  Future<void> _showAlertDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('DigiVote',style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            ),
            content: Text('Do you want to LOGOUT of DigiVote?'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop(false);
              }, child: Text('No')),
              TextButton(onPressed: () {
                // test=signUserOut();
                signUserOut();
                Navigator.of(context).pop(true);
              }, child: Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  // color: Colors.green,
                  // fontSize: 35,
                ),
              ),
              ),
            ],
          );
        }
    );
  }

  void signUserOut(){
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    FirebaseAuth.instance.signOut().then((value) {
      // pop the loading circle
      Navigator.pop(context);
      //showing message in snackbar
      showStatusMessage('Log-Out Successfull.', Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => loginpage())));
    });
    //navigating to loginpage
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => loginpage())));
    // Navigator.pop(context);
    // return true;
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

  // Future getDataFromDatabase() async {
  //   await FirebaseFirestore.instance.collection("Users").doc(user.uid).get().then((snapshot) {
  //     if(snapshot.exists){
  //       setState(() {
  //         name= snapshot.data()!['Name'];
  //       });
  //       // flag=1;
  //       // initState();
  //     }
  //   });
  // }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    g_name=widget.name;
    path=widget.profile_url;
    flag=1;
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: mytheme.prim,
              padding: EdgeInsets.only(top: 35),
              child: Column(
                children: [
                  Center(
                    child: MaterialButton(
                      onPressed: () {},
                      shape: CircleBorder(
                          side: BorderSide(
                              color: Colors.black, width: 2)
                      ),
                      child: CircleAvatar(
                        backgroundImage: (flag==0)?AssetImage(path):NetworkImage(path)as ImageProvider,
                        // AssetImage("lib/assets/images/demo_profile.jpeg"),
                        radius: 60,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      g_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 30),
                    child: Text(
                      user.email!,
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => profilepage()));
                    },
                    leading: Icon(
                      CupertinoIcons.profile_circled,
                      size: 30,
                    ),
                    iconColor: Colors.black,
                    title: Text(
                      "Profile",
                      style: TextStyle(color: Colors.black, fontSize: 19),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        testpage()));
                    // print("object");
                  },
                  leading: Icon(
                    CupertinoIcons.settings,
                    size: 30,
                  ),
                  iconColor: Colors.black,
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.black, fontSize: 19),
                  ),
                ),
                ListTile(
                  onTap: () {
                    print("object");
                  },
                  leading: Icon(
                    CupertinoIcons.question_circle,
                    size: 30,
                  ),
                  iconColor: Colors.black,
                  title: Text(
                    "FAQs",
                    style: TextStyle(color: Colors.black, fontSize: 19),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Share.share('Sharing Workings in our APP!!');
                    // print("object");
                  },
                  leading: Icon(
                    CupertinoIcons.share,
                    size: 30,
                  ),
                  iconColor: Colors.black,
                  title: Text(
                    "Share",
                    style: TextStyle(color: Colors.black, fontSize: 19),
                  ),
                ),
                ListTile(
                  onTap: () {
                    print("object");
                  },
                  leading: Icon(
                    Icons.people,
                    size: 30,
                  ),
                  iconColor: Colors.black,
                  title: Text(
                    "About Us",
                    style: TextStyle(color: Colors.black, fontSize: 19),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _showAlertDialog();
                    // signUserOut();
                  },
                  leading: Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  iconColor: Colors.black,
                  title: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black, fontSize: 19),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
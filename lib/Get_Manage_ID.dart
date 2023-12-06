import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Get_Manage_QR.dart';
import 'package:new_digivote/Give_ID.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/Manage_Election.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';

class getmanageidpage extends StatefulWidget {
  const getmanageidpage({required this.flag});
  final String flag;


  @override
  State<getmanageidpage> createState() => _getmanageidpageState();
}

class _getmanageidpageState extends State<getmanageidpage> {
  final _formkey = GlobalKey<FormState>();
  void initstate(){
    super.initState();
    // Navigator.pop(context);
    // dispose();
    // dispose();
    // dispose();
    // dispose();
    // Navigator.pop(context);
    // dispose();
  }

  final electionID=TextEditingController();
  final user_uid=FirebaseAuth.instance.currentUser?.uid;
  String electionId='';
  String uid='';
  String admin_uid='';
  String flag='';
  String user=FirebaseAuth.instance.currentUser!.uid;
  // int flag=0;

  void dispose () {
    electionID.dispose();
    super.dispose();
  }

  void exists(String ID) async {
    // show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    },
    );

    final snapshot = await FirebaseFirestore.instance
        .collection(ID).get();

    if ( snapshot.size == 0 ) {
      Navigator.pop(context);
      showStatusMessage("Does not Exists.", Colors.orange);
      print('Collection does not exist');
    }else {
      Future<String> stringFuture = getDataFromDatabase(ID);
      // Navigator.pop(context);
      admin_uid= await stringFuture;//getDataFromDatabase(ID).toString();
      print("Admin:"+admin_uid);
      // getDataFromDatabase(ID);
      print("Uid: "+uid);
      print(user);
      if(user==admin_uid)
        {
          print("Moving On...");
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: ID,flag: "0",)));
        }else{
        Navigator.pop(context);
        showStatusMessage("Not Authorised", Colors.yellow);
        print("Not Authorised.");
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: ID)));
      // print("Collection Exists");
    }
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

  Future<String> getDataFromDatabase(String ID) async {
    String answer='NA';
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
      print(snapshot.exists);
      if(snapshot.exists){
        print("Yes");
        // return snapshot.data()!['Admin_UID'];
        setState(() {
          print("StateState");
        uid= snapshot.data()!['Admin_UID'];
        // flag=1;
        // party= snapshot.data()!['Party'];
        });
        print("Setstate: "+uid);
        answer=uid;
        // return uid;
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }else{
        answer="NE";
      }
    });
    return answer;
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    flag=widget.flag;

    return WillPopScope(
      onWillPop: () async {
        int intflag=int.parse(flag);
        if(intflag==1){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mytheme.prim,
          title: Text(
            "Get Election ID",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 10),
              child: Center(
                child: Text(
                  "Enter the Election ID",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 5, 20),
              child: Container(
                child: Text(
                  "DigiVote manages your elections by their unique Ids. Please enter the 8 digit unique Id to explore continues",
                  style: context.captionStyle,
                  textScaleFactor: 1.05,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Form(
                      key: _formkey,
                      child: Container(
                        height: 82,
                        child: TextFormField(
                          controller: electionID,
                          // key: _formkey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field cannot be empty";
                            } else if (value.length < 8) {
                              return "Field cannot be short than 8 characters";
                            }
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                            // filled: true,
                            // labelText: "Username",
                            labelStyle: TextStyle(color: mytheme.prim),
                            focusedBorder: OutlineInputBorder(
                              // borderSide:
                              //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                borderSide: BorderSide(color: mytheme.prim),
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => manageqrscannnerpage()));
                              },
                              color: mytheme.prim,
                              icon: Icon(
                                Icons.qr_code_scanner_sharp,
                              ),
                              iconSize: 31,
                            ),
                            hintText: "Enter Election Id here...",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: mytheme.prim,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.black,
                        // overlayColor:
                        //     MaterialStateColor.resolveWith((states) => Colors.cyan),
                      ),
                      onPressed: () {
                        if(_formkey.currentState!.validate())
                          {
                            electionId=electionID.text.trim();
                            exists(electionId);
                          }
                        // electionId=electionID.text.trim();
                        // exists(electionId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              " Submit",
                              style: TextStyle(
                                fontSize: 25,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Icon(Icons.arrow_right),
                          ],
                        ),
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   // if(flag==1)
  //   //   {
  //   //     exists(electionId);
  //   //   }
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: mytheme.prim,
  //       title: Text("Get Election ID"),
  //       // actions: [
  //       //   IconButton(
  //       //       onPressed: signUserOut,
  //       //       icon: Icon(Icons.power_settings_new_rounded,color: Colors.white,)  //power_settings_new_rounded
  //       //   )
  //       // ],
  //     ),
  //     body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             TextFormField(
  //               controller: electionID,
  //
  //               decoration: InputDecoration(
  //                 // labelText: "Username",
  //                 labelStyle: TextStyle(color: mytheme.prim),
  //                 focusedBorder: OutlineInputBorder(
  //                   // borderSide:
  //                   //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
  //                     borderSide: BorderSide(color: mytheme.prim),
  //                     borderRadius: BorderRadius.all(Radius.circular(15))),
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(15))),
  //                 prefixIcon: Icon(
  //                   Icons.email_outlined,
  //                   color: mytheme.prim,
  //                 ),
  //                 hintText: "Enter election ID",
  //               ),
  //             ),
  //             // Text("LOGGED IN AS: "+user.email!),
  //             ElevatedButton(
  //                 child: Text('Manage Election'),
  //                 onPressed: () {
  //                   electionId=electionID.text.trim();
  //                   exists(electionId);
  //                   // Navigator.push(context, MaterialPageRoute(builder: (context) => giveElectionIDpage(ID: random,)));
  //                 }
  //             )
  //           ],
  //         )
  //     ),
  //   );
  // }
}

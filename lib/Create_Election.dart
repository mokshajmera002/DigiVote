import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Give_ID.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';

class createElectionpage extends StatefulWidget {
  const createElectionpage({Key? key}) : super(key: key);

  @override
  State<createElectionpage> createState() => _createElectionpageState();
}

class _createElectionpageState extends State<createElectionpage> {
  final _formkey = GlobalKey<FormState>();

  final electionName=TextEditingController();
  final user_uid=FirebaseAuth.instance.currentUser?.uid;
  String electionname='';

  void dispose () {
    electionName.dispose();
    super.dispose();
  }

  void addElectionDetails(String rand,String uid,String electionName,String status,String vcount) async {
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
    FirebaseFirestore.instance.collection(rand).doc("election_admin").set(   //map means the brackets for .add see mitch koko video for reference
        {
          'ID': rand,
          'Admin_UID':uid,
          'Election_Name': electionName,
          'Time Stamp':DateTime.now(),   //tolocal for loacl timezone
          'Status':status,
        }).then((value) {
      FirebaseFirestore.instance.collection(rand).doc("election_voted").set(   //map means the brackets for .add see mitch koko video for reference
          {
            'Voters Count': vcount,
          }).then((value) {
        // FirebaseFirestore.instance.collection("$rand/election_voted/Voters").doc("uid").set(   //map means the brackets for .add see mitch koko video for reference
        //     {
        //       'Default Count': vcount,
        //     }).then((value) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => giveElectionIDpage(ID: rand)));
        // });
      });
    });
    // FirebaseFirestore.instance.collection(rand).doc("election_voted").set(   //map means the brackets for .add see mitch koko video for reference
    //     {
    //       'Voters Count': vcount,
    //     });
    // FirebaseFirestore.instance.collection("$rand/election_voted/Voters").doc("uid").set(   //map means the brackets for .add see mitch koko video for reference
    //     {
    //       'Default Count': vcount,
    //     });
    // final userData = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); //if no name in doc() is given then automatically id will get generated
    // and we can access it by using userData.id
    // final json={
    //   'E-Mail': email,
    //   'National ID':nationalid,
    // };
    // await userData.set(json);
  }

  // electionname=electionName.text.trim();
  // String random=randomAlphaNumeric(8);
  // addElectionDetails(random, user_uid!, electionName.text.trim(),"continue","0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Create Election",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 10),
            child: Center(
              child: Text(
                "Enter the Election Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 5, 20),
            child: Container(
              child: Text(
                "DigiVote manages your elections by their unique Ids. Please enter the election name to explore continues",
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
                        controller: electionName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
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
                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => manageqrscannnerpage()));
                          //   },
                          //   color: mytheme.prim,
                          //   icon: Icon(
                          //     Icons.qr_code_scanner_sharp,
                          //   ),
                          //   iconSize: 31,
                          // ),
                          hintText: "Enter Election Name here...",
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
                        electionname=electionName.text.trim();
                        String random=randomAlphaNumeric(8);
                        addElectionDetails(random, user_uid!, electionName.text.trim(),"continue","0");
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
    );
  }
}

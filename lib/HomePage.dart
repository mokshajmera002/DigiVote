import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_digivote/Create_Election.dart';
import 'package:new_digivote/Get_Manage_ID.dart';
import 'package:new_digivote/Get_Result_ID.dart';
import 'package:new_digivote/Get_Show_Candidate_QR.dart';
import 'package:new_digivote/Show_Candidate_Data.dart';
import 'package:new_digivote/Show_Candidates.dart';
import 'package:new_digivote/drawer.dart';
import 'package:new_digivote/forgot_password.dart';
import 'package:new_digivote/login.dart';
import 'package:new_digivote/Get_Vote_QR.dart';
import 'package:new_digivote/result.dart';
// import 'package:digivote2/pages/listtile.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
    final electionID=TextEditingController();
    String id='';
    String name='';
    String profile_url='';
    String status='';
    String getstatus='';
    List<String> docIDs=[];
    List<String> IDs=[];
    int count=0;

    String user_uid=FirebaseAuth.instance.currentUser!.uid;

    void initState(){
      getDataFromDatabase();
      super.initState();
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

    Future getDataFromDatabase() async {
      await FirebaseFirestore.instance.collection("Users").doc(user_uid).get().then((snapshot) {
        if(snapshot.exists){
          setState(() {
            name= snapshot.data()!['Name'];
            profile_url= snapshot.data()!['Profile URL'];
          });
          // flag=1;
          // initState();
        }
      });
    }

    Future<String> getElectionDataFromDatabase(String ID) async {
      String answer="NA";
      await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
        if(snapshot.exists){
          setState(() {
            status= snapshot.data()!['Status'];
            answer=status;
          });
          // flag=1;
          // initState();
        }else {
          answer="NE";
        }
      });
      return answer;
    }

    Future getDocId(String ID)async {
      await FirebaseFirestore.instance.collection("$ID/election_voted/Voters").get()
          .then(
            (snapshot) => snapshot.docs.forEach((document) {
          docIDs.add(document.reference.id);
          print(document.reference.id);
        }),
      );
      // getvoteId(docIDs);
    }

    // Future getIDDocId(String ID)async {
    //   await FirebaseFirestore.instance.collection(ID).get()
    //       .then(
    //         (snapshot) => snapshot.docs.forEach((document) {
    //       IDs.add(document.reference.id);
    //       print(document.reference.id);
    //     }),
    //   );
    //   // getvoteId(docIDs);
    // }

    void loop(String ID,String name,String profile_url) async {
      docIDs = [];
      IDs = [];
      count = 0;
      // await getIDDocId(ID);
      // show loading circle
      // showDialog(context: context, builder: (context)
      // {
      //   return const Center(
      //     child: CircularProgressIndicator(
      //       color: Colors.black,
      //     ),
      //   );
      // }
      // );
      // for (var i = 0; i < IDs.length; i++) {
      //   print("DocID: "+IDs[i]);
      //   // print("Match: "+(user_uid==docIDs[i]).toString());
      //   if("election_voted"==IDs[i]){
      //     print("election_voted found");
      //     // Navigator.pop(context);
      //     await getDocId(ID);
      //     for (var j = 0; j < docIDs.length; j++) {
      //       print("DocID: "+docIDs[j]);
      //       print("Match: "+(user_uid==docIDs[j]).toString());
      //       if(user_uid==docIDs[j]){
      //         print("No Voting");
      //         Navigator.pop(context);
      //         showStatusMessage("You already voted once.", Colors.brown);
      //         break;
      //       }else{
      //         Navigator.pop(context);
      //         Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
      //       }
      //     }
      //     // break;
      //   }
      //   else if(IDs.length==1)
      //     {
      //       print("election_admin only found");
      //       Navigator.pop(context);
      //       Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
      //       // continue;
      //     }
      //   else{
      //     // Navigator.pop(context);
      //     print("election_voted not found");
      //     if(i==1)
      //       {
      //         print("pushing to next page");
      //         Navigator.pop(context);
      //         Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
      //       }
      //     // Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
      //   }
      // }

      // show loading circle
      showDialog(context: context, builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        );
      }
      );
      final snapshot = await FirebaseFirestore.instance.collection(ID).get();
      if (snapshot.size == 0) {
        Navigator.pop(context);
        showStatusMessage("ID does not Exists.", Colors.orange);
        print('Collection does not exist');
      } else {
        Future<String> stringFuture = getElectionDataFromDatabase(ID);
        // Navigator.pop(context);
        getstatus = await stringFuture; //getDataFromDatabase(ID).toString();
        if (getstatus != "Stop") {
          await getDocId(ID);
          for (var i = 0; i < docIDs.length; i++) {
            print("DocID: " + docIDs[i]);
            print("Match: " + (user_uid == docIDs[i]).toString());
            if (user_uid == docIDs[i]) {
              count++;
              print("Count: " + count.toString());
              // Navigator.pop(context);
              // showStatusMessage("You already voted once.", Colors.brown);
              break;
            }
            // else{
            //   Navigator.pop(context);
            //   Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
            // }
          }
          if (count == 0) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                showcandidatespage(ID: id, name: name, flag: "0",profile_url: profile_url,)));
          } else {
            print("No Voting");
            Navigator.pop(context);
            showStatusMessage("You already voted once.", Colors.brown);
          }
        } else {
          Navigator.pop(context);
          showStatusMessage("Voting is stopped.", Colors.pinkAccent);
        }
      }
    }

    // Future<String> getvoteDataFromDatabase(String ID) async {
    //   String answer='NA';
    //   // showDialog(context: context, builder: (context)
    //   // {
    //   //   return const Center(
    //   //     child: CircularProgressIndicator(),
    //   //   );
    //   // },
    //   // );
    //   getDocId(ID);
    //   print("DocID: "+docIDs[1]);
    //   if(docIDs=="election_voted"){
    //     await FirebaseFirestore.instance.collection("$ID/election_voted/Voters").doc(user_uid).get().then((snapshot) {
    //       print(snapshot.exists);
    //       if(snapshot.exists){
    //         print("Yes");
    //         // return snapshot.data()!['Admin_UID'];
    //         setState(() {
    //           print("StateState");
    //           status= snapshot.data()!['Finish'];
    //           // flag=1;
    //           // party= snapshot.data()!['Party'];
    //         });
    //         // print("Setstate: "+uid);
    //         answer=status;
    //         // return uid;
    //         // Navigator.pop(context);
    //         // flag=1;
    //         // initState();
    //       }else{
    //         answer="NE";
    //       }
    //     });
    //   }else{
    //     answer="Fuck";
    //   }
    //   return answer;
    //   // Navigator.pop(context);
    // }

    // void voted(String ID,String name) async {
    //   // show loading circle
    //   showDialog(context: context, builder: (context)
    //   {
    //     return const Center(
    //       child: CircularProgressIndicator(
    //         color: Colors.black,
    //       ),
    //     );
    //   },
    //   );
    //
    //   Future<String> stringFuture = getvoteDataFromDatabase(ID);
    //   // Navigator.pop(context);
    //   status= await stringFuture;//getDataFromDatabase(ID).toString();
    //   print("Status:"+status);
    //   // getDataFromDatabase(ID);
    //   if(status=="voted")
    //   {
    //     print("No Voting");
    //     Navigator.pop(context);
    //     showStatusMessage("You already voted once.", Colors.brown);
    //     // Navigator.push(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: ID)));
    //   }else{
    //     Navigator.pop(context);
    //     Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
    //   }
    //   // Navigator.push(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: ID)));
    //   // print("Collection Exists");
    // }

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

  final _formkey = GlobalKey<FormState>();

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop:() async {
        // final value =
        await _showAlertDialog();
        return false;
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('DigiVote',style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //         ),
        //         ),
        //         content: Text('Do you want to LOGOUT of DigiVote?'),
        //         actions: [
        //           TextButton(onPressed: () {
        //             Navigator.of(context).pop(false);
        //           }, child: Text('No')),
        //           TextButton(onPressed: () {
        //             // test=signUserOut();
        //             signUserOut();
        //             Navigator.of(context).pop(true);
        //           }, child: Text(
        //             'Yes',
        //             style: TextStyle(
        //               fontWeight: FontWeight.w900,
        //               // color: Colors.green,
        //               // fontSize: 35,
        //             ),
        //           ),
        //           ),
        //         ],
        //       );
        //     });
        // if(value!=null)
        // {
        //   return Future.value(value);
        // }else {
        //   return Future.value(false);
        // }
      },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "DigiVote",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: mytheme.prim,
            actions: [
              IconButton(
                  onPressed: _showAlertDialog//signUserOut
                  , icon: Icon(Icons.power_settings_new_rounded,color: Colors.black,)) //power_settings_new_rounded
            ],
          ),
          drawer: drawerpage(name: name,profile_url: profile_url),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                  child: Text(
                    "ENTER A VOTE CODE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: mytheme.prim),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 35, 0, 0),
                      child: Container(
                        width: 250,
                        height: 100,
                        child: Form(
                          key: _formkey,
                          child: TextFormField(
                            // key: _formkey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value.length < 8) {
                                return "Password cannot be short than 8 characters";
                              }
                              setState(() {

                              });
                              // return null;
                            },
                            onChanged:  (value) {
                              setState(() {});
                            },
                            controller: electionID,
                            decoration: InputDecoration(
                              // filled: true,
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
                              suffixIcon: IconButton(
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatesqrscannnerpage(ID: electionID.text.trim(), name: name,profile_url: profile_url,)));
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                            if(_formkey.currentState!.validate()){
                              id=electionID.text.trim();
                              // voted(id,name);
                              loop(id, name,profile_url);
                            }
                            // id=electionID.text.trim();
                            // // voted(id,name);
                            // loop(id, name);
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => showcandidatespage(ID: id,name: name)));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.check_circle),
                              Text(
                                " Vote",
                                style: TextStyle(
                                  fontSize: 20,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 15, 10),
                      child: Container(
                        height: 200,
                        width: 160,
                        // color: mytheme.prim,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [mytheme.prim, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => createElectionpage()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.how_to_vote_outlined,
                                size: 130,
                              ),
                              Text("Create Election"),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(100, 5, 5, 0),
                                  child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 35,
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                      child: Container(
                        height: 200,
                        width: 160,
                        // color: mytheme.prim,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [mytheme.prim, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => getmanageidpage(flag: "0",)));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 3,
                              ),
                              Icon(
                                Icons.dns_outlined,
                                size: 130,
                              ),
                              Text("Manage Election"),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(100, 5, 5, 0),
                                  child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 35,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 15, 10),
                      child: Container(
                        height: 200,
                        width: 160,
                        // color: mytheme.prim,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [mytheme.prim, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => getresultid()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.view_list_outlined,
                                size: 130,
                              ),
                              Text("View Results"),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(100, 5, 5, 0),
                                  child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 35,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                      child: Container(
                        height: 200,
                        width: 160,
                        // color: mytheme.prim,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [mytheme.prim, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          onPressed: () {
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => getidpage()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                CupertinoIcons.question_circle,
                                size: 130,
                              ),
                              Text("FAQs"),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(100, 5, 5, 0),
                                  child: Icon(
                                    Icons.arrow_circle_right_outlined,
                                    size: 35,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
}
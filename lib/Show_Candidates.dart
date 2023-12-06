import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Create_Candidate.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/View_Voters.dart';
import 'package:new_digivote/Manage_Candidate_Data.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Show_Candidate_Data.dart';

class showcandidatespage extends StatefulWidget {
  const showcandidatespage({required this.ID,required this.name,required this.flag,required this.profile_url});
  final String ID;
  final String name;
  final String flag;
  final String profile_url;

  @override
  State<showcandidatespage> createState() => showcandidatespageState();
}

class showcandidatespageState extends State<showcandidatespage> {

  String id = '';
  String new_name = '';
  String status='';
  String getstatus='';
  String new_flag='';
  String new_profile_url='';

  //length=docIDs.length
  //to get values write docIDs[index]
  List<String> docIDs = [];
  // List<String> voteIDs = [];

  //geting document ids
  // Future getDocId(String ID) async {
  //   await FirebaseFirestore.instance.collection('$ID/election_admin/Candidates')
  //       .get()
  //       .then(
  //         (snapshot) =>
  //         snapshot.docs.forEach((document) {
  //           docIDs.add(document.reference.id);
  //           // getvoteId(document.reference.id);
  //           // print(document.reference.id);
  //         }),
  //   );
  //   // getvoteId(docIDs);
  // }

  // void stopElection(String ID,String name) async {
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   await FirebaseFirestore.instance.collection(ID).doc("election_admin").update({
  //     'Status': name,
  //   })//.set(   //map means the brackets for .add see mitch koko video for reference
  //   // {
  //   //   'Status': name,
  //   //   // 'Party':party,
  //   // })
  //       .then((value) {
  //     Navigator.pop(context);
  //     showStatusMessage("Election Stopped Successfully.", Colors.green);
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
  //   })
  //       .onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.red);
  //   });
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

  // void createCandidate(String ID) async{
  //   // show loading circle
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(
  //         color: Colors.redAccent,
  //       ),
  //     );
  //   },
  //   );
  //   Future<String> stringFuture = getDataFromDatabase(ID);
  //   // Navigator.pop(context);
  //   getstatus= await stringFuture;//getDataFromDatabase(ID).toString();
  //   if(getstatus=="Stop")
  //   {
  //     Navigator.pop(context);
  //     showStatusMessage("Sorry Election is Stopped.", Colors.brown);
  //   }else{
  //     Navigator.pop(context);
  //     Navigator.of(context).push(MaterialPageRoute(builder: ((context) => createcandidatepage(ID: ID))));
  //   }
  //
  // }

  // Future<String> getDataFromDatabase(String ID) async {
  //   String answer="NA";
  //   // showDialog(context: context, builder: (context)
  //   // {
  //   //   return const Center(
  //   //     child: CircularProgressIndicator(
  //   //       backgroundColor: Colors.red,
  //   //     ),
  //   //   );
  //   // },
  //   // );
  //   await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
  //     print(snapshot.exists);
  //     if(snapshot.exists){
  //       print("Yes");
  //       setState(() {
  //         status= snapshot.data()!['Status'];
  //         answer=status;
  //         // party= snapshot.data()!['Party'];
  //       });
  //       // Navigator.pop(context);
  //       // flag=1;
  //       // initState();
  //     }else{
  //       answer="NE";
  //     }
  //   });
  //   return answer;
  // }

  // Future<void> _pullRefresh() async {
  //   List<String> freshNumbers = await NumberGenerator().slowNumbers();
  //   setState(() {
  //     numbersList = freshNumbers;
  //   });
  //   // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  // }

  // Future getvoteId(String docid)async {
  //   await FirebaseFirestore.instance.collection('1FC5XMfi/election_admin/Candidates/${docid}/Vote').get()
  //       .then(
  //         (snapshot) => snapshot.docs.forEach((document) {
  //       voteIDs.add(document.reference.id);
  //       print(document.reference.id);
  //     }),
  //   ).onError((error, stackTrace) {
  //     print(error);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    id = widget.ID;
    new_name = widget.name;
    new_flag = widget.flag;
    new_profile_url = widget.profile_url;
    print("works");
    // flag++;
    return WillPopScope(
      onWillPop: () async {
        int intflag=int.parse(new_flag);
        if(intflag==1){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Show Candidates",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          // centerTitle: true,
          backgroundColor: mytheme.prim,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded( //will give error if the field in any candidate is not present
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('$id/election_admin/Candidates').snapshots(), //getting the doc id
                  builder: (context, streamSnapshot){  //AsyncSnapshot<QuerySnapshot>
                    print(FirebaseFirestore.instance.collection('$id/election_admin/Candidates').snapshots());
                    print(streamSnapshot.hasData);
                    if(streamSnapshot.hasData) //streamSnapshot.connectionState == ConnectionState.active
                        {
                      print("Data presence:"+streamSnapshot.hasData.toString());
                      return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            print("Print:"+streamSnapshot.data!.docs[index].id);
                            final DocumentSnapshot documentSnapshot=streamSnapshot.data!.docs[index];
                            return SizedBox(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  child: ListTile(
                                    onTap: () {
                                      print("object");
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>
                                              showcandidatedatapage(
                                                  ID: id,docID: streamSnapshot.data!.docs[index].id,name: new_name,user_profile_url: new_profile_url,)));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(150),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(documentSnapshot['Profile URL']),
                                        radius: 38,
                                      ),//Image.network(documentSnapshot['Profile URL']) as ImageProvider), //Image.network(documentSnapshot['Profile URL']), //demo_profile //AssetImage("lib/assets/images/bjp.png")
                                    ),

                                    iconColor: Colors.black,
                                    title: Text(documentSnapshot['Name'], style: context.titleLarge),
                                    subtitle: Text(
                                      documentSnapshot['Party'],
                                      // "mca@gmail.com",
                                      style: context.captionStyle,
                                      textScaleFactor: 1.1,
                                    ),
                                    // trailing: Text(
                                    //   "15000 Vote(s)",
                                    //   textScaleFactor: 1.1,
                                    //   style: TextStyle(fontWeight: FontWeight.bold),
                                    // ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ),
                            );

                          });
                    }
                    // else if(streamSnapshot.connectionState == ConnectionState.waiting) {
                    //   print("Data Loading..");
                    //   return Text("Data Loading..");
                    //   // return const Center(
                    //   //   child: CircularProgressIndicator(),
                    //   // );
                    // }
                    else{
                      print("No Data");
                      return Text("No Entries.");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


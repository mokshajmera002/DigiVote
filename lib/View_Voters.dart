import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Create_Candidate.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/Manage_Candidate_Data.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:velocity_x/velocity_x.dart';

import 'View_Voters_Data.dart';

class viewvoterspage extends StatefulWidget {
  const viewvoterspage({required this.ID});
  final String ID;

  @override
  State<viewvoterspage> createState() => viewvoterspageState();
}

class viewvoterspageState extends State<viewvoterspage> {

  String id = '';

  //length=docIDs.length
  //to get values write docIDs[index]
  List<String> docIDs = [];
  // List<String> voteIDs = [];

  //geting document ids
  Future getDocId(String ID) async {
    await FirebaseFirestore.instance.collection('$ID/election_voted/Voters')
        .get()
        .then(
          (snapshot) =>
          snapshot.docs.forEach((document) {
            docIDs.add(document.reference.id);
            // getvoteId(document.reference.id);
            // print(document.reference.id);
          }),
    );
    // getvoteId(docIDs);
  }

  // void deleteVoter(String ID) async{
  //   await Firestore.instance.collection("chats").document("ROOM_1")
  //       .collection("messages").document(snapshot.data.documents[index]["id"])
  //       .delete();
  //
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
    print("works");
    // flag++;
    return Scaffold(
      appBar: AppBar(
        title: Text("View Voters",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        // centerTitle: true,
        backgroundColor: mytheme.prim,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('$id/election_voted/Voters').snapshots(), //getting the doc id
                builder: (context,streamSnapshot){ //AsyncSnapshot<QuerySnapshot>
                  print(streamSnapshot.data?.docs.length);
                  if(streamSnapshot.hasData)
                  {
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
                                    // print("object");
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) =>
                                    //         viewvotersdatapage(
                                    //             ID: id,docID: streamSnapshot.data!.docs[index].id)));
                                  },
                                  leading: ClipRRect(
                                    // borderRadius: BorderRadius.circular(150),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(documentSnapshot['Profile URL']),
                                      radius: 38,
                                    ), //demo_profile//AssetImage("lib/assets/images/demo_profile.jpeg"))
                                  ),

                                  iconColor: Colors.black,
                                  title: Text(documentSnapshot['Name'], style: context.titleLarge),
                                  subtitle: Text(
                                    documentSnapshot['E-Mail'],
                                    // "mca@gmail.com",
                                    style: context.captionStyle,
                                    textScaleFactor: 1.1,
                                  ),
                                  // trailing: Text(
                                  //   "15000 Vote(s)",
                                  //   textScaleFactor: 1.1,
                                  //   style: TextStyle(fontWeight: FontWeight.bold),
                                  // ),
                                  // trailing: IconButton(icon: Icon(Icons.arrow_forward_ios),onPressed: () {
                                  //   print("object");
                                  //   Navigator.push(context,
                                  //       MaterialPageRoute(builder: (context) =>
                                  //           viewvotersdatapage(
                                  //               ID: id,docID: streamSnapshot.data!.docs[index].id)));
                                  // },
                                  // ),

                                ),
                              ),
                            ),
                          );

                        }
                        );
                  }
                    print("No data");
                    return const Text("No Voters Till Now");
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );

                },
              ),
            )
          ],
        ),
      ),

    );
  }
}


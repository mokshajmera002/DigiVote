import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Create_Candidate.dart';
import 'package:new_digivote/Get_Result_ID.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/View_Voters.dart';
import 'package:new_digivote/Manage_Candidate_Data.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:velocity_x/velocity_x.dart';

class resultpage extends StatefulWidget {
  const resultpage({required this.ID,required this.flag});
  final String ID;
  final String flag;

  @override
  State<resultpage> createState() => resultpageState();
}

class resultpageState extends State<resultpage> {

  String id = '';
  String new_flag='';

  //to get values write docIDs[index]
  List<String> docIDs = [];

  @override
  Widget build(BuildContext context) {
    id = widget.ID;
    new_flag = widget.flag;
    print("works");
    // flag++;
    return WillPopScope(
      onWillPop: () async {
        int intflag=int.parse(new_flag);
        if(intflag==1){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => getresultid()));
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Result Election",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                  builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
                    if(streamSnapshot.hasData)
                    {
                      return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            final DocumentSnapshot documentSnapshot=streamSnapshot.data!.docs[index];
                            return SizedBox(
                              height: 140,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          // print("object");
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(builder: (context) =>
                                          //         viewvotersdatapage(
                                          //             ID: id,docID: streamSnapshot.data!.docs[index].id)));
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
                                        // trailing: IconButton(icon: Icon(Icons.arrow_forward_ios),onPressed: () {
                                        //   print("object");
                                        //   Navigator.push(context,
                                        //       MaterialPageRoute(builder: (context) =>
                                        //           viewvotersdatapage(
                                        //               ID: id,docID: streamSnapshot.data!.docs[index].id)));
                                        // },
                                        // ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(250, 10, 5, 0),
                                        child: Text(documentSnapshot['Count']+" Vote(s)",
                                            textScaleFactor: 1.1,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }else {
                      print("No data");
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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


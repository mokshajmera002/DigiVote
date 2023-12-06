import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/Manage_Candidate_Data.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:velocity_x/velocity_x.dart';

class recyclerlist extends StatefulWidget {
  const recyclerlist({Key? key}) : super(key: key);

  @override
  State<recyclerlist> createState() => _recyclerlistState();
}

class _recyclerlistState extends State<recyclerlist> {

  //length=docIDs.length
  //to get values write docIDs[index]
  List<String> docIDs=[];
  List<String> voteIDs=[];

  //geting document ids
  Future getDocId()async {
    await FirebaseFirestore.instance.collection('53G4VE27/election_admin/Candidates').get()
        .then(
            (snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
              getvoteId(document.reference.id);
              print(document.reference.id);
            }),
    );
    // getvoteId(docIDs);
  }

  Future getvoteId(String docid)async {
    await FirebaseFirestore.instance.collection('1FC5XMfi/election_admin/Candidates/${docid}/Vote').get()
        .then(
          (snapshot) => snapshot.docs.forEach((document) {
        voteIDs.add(document.reference.id);
        print(document.reference.id);
      }),
    ).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // flag++;
    return Scaffold(
      appBar: AppBar(
        title: Text("Candidates"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('53G4VE27/election_admin/Candidate').snapshots(), //getting the doc id
                builder: (context,streamSnapshot){ //AsyncSnapshot<QuerySnapshot>
                  print("Connection state: "+streamSnapshot.connectionState.toString());
                  print("Has Data: "+streamSnapshot.hasData.toString());
                  if(streamSnapshot.hasData)
                    {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context,index){
                            print("Length of doc:"+streamSnapshot.data!.docs.length.toString());
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
                                    },
                                    leading: ClipRRect(
                                          // borderRadius: BorderRadius.circular(150),
                                          child: Image(height: 300,
                                              image: AssetImage("lib/assets/images/bjp.png")), //demo_profile
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
                                  ),
                                ),
                              ),
                            );

                          });
                    }else {
                    print("No data");
                    return Text("Firestore is empty");
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                },
              ),
              // child: FutureBuilder(
              //   future: getDocId(),   //data to be displayed
              //   builder: (context, snapshot) {
              //     print(docIDs.length);
              //     if(docIDs.isEmpty)
              //       {
              //         return Text("data");
              //       }
              //     return ListView.builder(
              //       itemCount: docIDs.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.all(6.0),
              //           child: Card(
              //             shape:
              //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //             child: MaterialButton(
              //               onPressed: () {
              //                 Navigator.push(context,
              //                     MaterialPageRoute(builder: (context) => candidatedatapage(ID: docIDs[index],)));
              //               },
              //               child: Row(children: [
              //                 Padding(
              //                   padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
              //                   child: Container(
              //                     child: CircleAvatar(
              //                       radius: 50,
              //                       backgroundImage:
              //                       AssetImage("lib/assets/images/demo_profile.jpeg"),
              //                     ),
              //                   ),
              //                 ),
              //                 Column(
              //                   children: [
              //                     Container(
              //                       width: 200,
              //                       child: GetUserName(documentId: docIDs[index]),//Text(
              //                         // "Moksh Chandreshbhai Ajmera",
              //                         // style: context.titleMedium,
              //                         // textScaleFactor: 1.1,
              //                         // textAlign: TextAlign.left,
              //                       // ),
              //                     ),
              //                     // SizedBox(
              //                     //   height: 15,
              //                     // ),
              //                     Padding(
              //                       padding: const EdgeInsets.fromLTRB(0, 2, 87, 10),
              //                       child: Text(
              //                         "mca@gmail.com",
              //                         style: context.captionStyle,
              //                         textScaleFactor: 1.1,
              //                         textAlign: TextAlign.left,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 Icon(Icons.arrow_forward_ios)
              //               ]
              //               ),
              //             ),
              //           ),
              //         );
              //         // return ListTile(
              //         //   title: GetUserName(documentId: docIDs[index]),
              //         //   subtitle: Text('Result: ${voteIDs.length}'),
              //         // );
              //       });
              //   }
              // ),
            )
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {},
      backgroundColor: mytheme.prim,
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
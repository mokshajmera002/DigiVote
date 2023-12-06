import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Create_Candidate.dart';
import 'package:new_digivote/Get_Manage_ID.dart';
import 'package:new_digivote/Manage_Generate_QR.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/View_Voters.dart';
import 'package:new_digivote/Manage_Candidate_Data.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:velocity_x/velocity_x.dart';

class manageelectionpage extends StatefulWidget {
  const manageelectionpage({required this.ID,required this.flag});
  final String ID;
  final String flag;

  @override
  State<manageelectionpage> createState() => manageelectionpageState();
}

class manageelectionpageState extends State<manageelectionpage> {

  String id = '';
  String status='';
  String getstatus='';
  String new_flag='';

  //length=docIDs.length
  //to get values write docIDs[index]
  List<String> docIDs = [];
  List<String> voteIDs = [];

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

  void stopElection(String ID,String name) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").update({
      'Status': name,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
        // {
        //   'Status': name,
        //   // 'Party':party,
        // })
    .then((value) {
      Navigator.pop(context);
      showStatusMessage("Election Stopped Successfully.", Colors.green);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    })
      .onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
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

  void createCandidate(String ID) async{
    // show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      );
    },
    );
    Future<String> stringFuture = getDataFromDatabase(ID);
    // Navigator.pop(context);
    getstatus= await stringFuture;//getDataFromDatabase(ID).toString();
    if(getstatus=="Stop")
      {
        Navigator.pop(context);
        showStatusMessage("Sorry Election is Stopped.", Colors.brown);
      }else{
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => createcandidatepage(ID: ID))));
    }

  }

  Future<String> getDataFromDatabase(String ID) async {
    String answer="NA";
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
      print(snapshot.exists);
      if(snapshot.exists){
        print("Yes");
        setState(() {
          status= snapshot.data()!['Status'];
          answer=status;
          // party= snapshot.data()!['Party'];
        });
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }else{
        answer="NE";
      }
    });
    return answer;
  }

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
    new_flag=widget.flag;
    print("works");
    // flag++;
    return WillPopScope(
      onWillPop: () async {
        int intflag=int.parse(new_flag);
        if(intflag==1){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => getmanageidpage(flag: "1")));
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mytheme.prim,
          title: Text("Manage Election",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          // centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => managegenerateqrpage(ID: id)));
                }
                , icon: Icon(Icons.qr_code_2_rounded,color: Colors.black,)
            ) //power_settings_new_rounded
          ],
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
                                              managecandidatedatapage(
                                                  ID: id,docID: streamSnapshot.data!.docs[index].id)));
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
                //fetch data can be also done by futurebuider
                // child: FutureBuilder(
                //     future: getDocId(id), //data to be displayed
                //     builder: (context, snapshot) {
                //       print(docIDs.length);
                //       if (docIDs.isEmpty) {
                //         return Text(
                //             "Create a candidate \n Candidates will appear here.");
                //       }
                //       return ListView.builder(
                //           itemCount: docIDs.length,
                //           itemBuilder: (context, index) {
                //             // final DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];//.docIds[index];
                //             // ignore: prefer_interpolation_to_compose_strings
                //             print("Print: "+snapshot.data.docs[index]);
                //             return Padding(
                //               padding: const EdgeInsets.all(6.0),
                //               child: Card(
                //                 shape:
                //                 RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(20)),
                //                 child: MaterialButton(
                //                   onPressed: () {
                //                     // Navigator.push(context,
                //                     //     MaterialPageRoute(builder: (context) =>
                //                     //         candidatedatapage(
                //                     //           ID: docIDs[index],)));
                //                   },
                //                   child: Row(children: [
                //                     Padding(
                //                       padding: const EdgeInsets.fromLTRB(
                //                           0, 8, 12, 8),
                //                       child: Container(
                //                         child: CircleAvatar(
                //                           radius: 50,
                //                           backgroundImage:
                //                           AssetImage(
                //                               "lib/assets/images/demo_profile.jpeg"),
                //                         ),
                //                       ),
                //                     ),
                //                     Column(
                //                       children: [
                //                         Container(
                //                           width: 200,
                //                           // child: Text(documentSnapshot['Name']),//style: context.titleMedium,textScaleFactor: 1.1,textAlign: TextAlign.left),//GetUserName(documentId: docIDs[index]), //Text(
                //                           // "Moksh Chandreshbhai Ajmera",
                //                           // style: context.titleMedium,
                //                           // textScaleFactor: 1.1,
                //                           // textAlign: TextAlign.left,
                //                           // ),
                //                         ),
                //                         // SizedBox(
                //                         //   height: 15,
                //                         // ),
                //                         Padding(
                //                           padding: const EdgeInsets.fromLTRB(0, 2, 87, 10),
                //                           // child: Text(documentSnapshot['Party'],style: context.titleMedium,textScaleFactor: 1.1,textAlign: TextAlign.left),
                //
                //                           // child: Text(
                //                           //   "mca@gmail.com",
                //                           //   style: context.captionStyle,
                //                           //   textScaleFactor: 1.1,
                //                           //   textAlign: TextAlign.left,
                //                           // ),
                //                         ),
                //                       ],
                //                     ),
                //                     Icon(Icons.arrow_forward_ios)
                //                   ]
                //                   ),
                //                 ),
                //               ),
                //             );
                //             // return ListTile(
                //             //   title: GetUserName(documentId: docIDs[index]),
                //             //   subtitle: Text('Result: ${voteIDs.length}'),
                //             // );
                //           });
                //     }
                // ),
              )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: mytheme.prim,
          spaceBetweenChildren: 13,
          spacing: 10,
          // animationDuration: Duration(milliseconds: 5000),
          // closeManually: true,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              // foregroundColor: mytheme.prim,
              child: Icon(
                Icons.library_add,
              ),
              label: 'Create Candidate',
              onTap: () {
                createCandidate(id);
                // getDataFromDatabase(id);
                // if(status=="Stop")
                //   {
                //     showStatusMessage("Election is stopped", Colors.yellow);
                //   }else {
                //   print("Going on create candidate");
                //   Navigator.of(context).push(MaterialPageRoute(builder: ((context) => createcandidatepage(ID: id))));
                // }
                // Navigator.of(context).push(MaterialPageRoute(builder: ((context) => createcandidatepage(ID: id))));
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return tile();
                //   },
                // ));
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.visibility,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => viewvoterspage(ID: id))));
              },
              label: 'View Voters',
            ),
            SpeedDialChild(
              child: Icon(
                Icons.block,
              ),
              onTap: () {
                stopElection(id, "Stop");
              },
              label: 'Stop Voting',
            )
          ],
        ),
      ),
    );
  }
}


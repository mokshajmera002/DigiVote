import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/widgets/themes.dart';


class viewvotersdatapage extends StatefulWidget {
  const viewvotersdatapage({required this.ID,required this.docID});
  final String ID;
  final String docID;

  @override
  State<viewvotersdatapage> createState() => _viewvotersdatapageState();
}

class _viewvotersdatapageState extends State<viewvotersdatapage> {

  int flag=0;
  // String? id='';
  String name='Loading..';
  String email='Loading..';
  String count='';
  // String party='Loading..';
  // String position='Loading..';
  String new_ID='';
  String new_docID='';

  // final namecontroller=TextEditingController();
  // final partycontroller=TextEditingController();
  // final positioncontroller=TextEditingController();

  // void initState() {
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

  Future getDataFromDatabase(String ID,String doc) async {
    await FirebaseFirestore.instance.collection("$ID/election_voted/Voters").doc(doc).get().then((snapshot) {
      if(snapshot.exists){
        setState(() {
          name= snapshot.data()!['Name'];
          email= snapshot.data()!['E-Mail'];

          FirebaseFirestore.instance.collection(ID).doc("election_voted").get().then((snapshot) {
            if(snapshot.exists){
              setState(() {
                count= snapshot.data()!['Voters Count'];
              });
            }
          });

        });
        flag=1;
        // initState();
      }
    });
  }

  // void deleteVoter(String ID,String doc,String count) async{
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   await FirebaseFirestore.instance.collection("$ID/election_voted/Voters").doc(doc).delete().then((value) {
  //    updateCount(ID, doc, count);
  //   });
  //
  // }

  // void updateCount(String ID,String doc,String count) async {
  //   // showDialog(context: context, builder: (context)
  //   // {
  //   //   return const Center(
  //   //     child: CircularProgressIndicator(),
  //   //   );
  //   // },
  //   // );
  //   await FirebaseFirestore.instance.collection(ID).doc("election_voted").update({
  //     'Voters Count': count,
  //   }).then((value) {
  //     Navigator.pop(context);
  //     showStatusMessage("Voter Deleted Successfully.", Colors.green);
  //     // getDataFromDatabase(ID, doc);
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.red);
  //   });
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
    new_ID=widget.ID;
    new_docID=widget.docID;
    // print(new_ID);
    if(flag==0)
    {
      print("getdata");
      getDataFromDatabase(new_ID,new_docID);
    }else{
      print("moksh");
    }

    // getDataFromDatabase();
    // print(new_ID);
    // flag=1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Voter Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                      AssetImage("lib/assets/images/demo_profile.jpeg"),
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
                        onPressed: () {},
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
                  child: Text(name,
                    // "Raj Ganatra",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
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
                    "E-Mail",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(email,
                    // "BJP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            //   child: Divider(),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            //   child: ListTile(
            //     leading: Icon(Icons.label_outline),
            //     title: Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //       child: Text(
            //         "Position",
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 14,
            //             color: Colors.grey),
            //       ),
            //     ),
            //     subtitle: Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            //       child: Text(position,
            //         // "Persident",
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //             color: Colors.black),
            //       ),
            //     ),
            //     trailing: Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
            //       child: IconButton(
            //         icon: Icon(Icons.edit),
            //         color: mytheme.darkcreme,
            //         onPressed: () {
            //           showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return AlertDialog(
            //
            //                   title: Text('Enter new position',style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   ),
            //                   content: TextFormField(
            //                     controller: positioncontroller,
            //                     decoration: InputDecoration(
            //                       filled: true,
            //                       // labelText: "Username",
            //                       labelStyle: TextStyle(color: mytheme.prim),
            //                       focusedBorder: OutlineInputBorder(
            //                         // borderSide:
            //                         //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
            //                           borderSide: BorderSide(color: mytheme.prim),
            //                           borderRadius: BorderRadius.all(Radius.circular(15))),
            //                       border: OutlineInputBorder(
            //                           borderRadius: BorderRadius.all(Radius.circular(15))),
            //                       hintText: position,
            //                     ),
            //                   ),//Text('Do you want to LOGOUT of DigiVote?'),
            //                   actions: [
            //                     // ElevatedButton(onPressed: () {}, child: Text("Button")),
            //                     TextButton(onPressed: () {
            //                       Navigator.of(context).pop(false);
            //                     }, child: Text('Cancel')),
            //                     TextButton(onPressed: () {
            //                       // test=signUserOut();
            //                       updatePosition(new_ID, new_docID, positioncontroller.text.trim());
            //                       Navigator.of(context).pop(true);
            //                     }, child: Text(
            //                       'Save',
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w900,
            //                         // color: Colors.green,
            //                         // fontSize: 35,
            //                       ),
            //                     ),
            //                     ),
            //                   ],
            //                 );
            //               });
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
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
                    // deleteVoter(new_ID, new_docID, count);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          " Delete Voter",
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
            )
          ],
        ),
      ),
    );
  }
}

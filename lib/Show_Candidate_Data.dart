import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/verify_face.dart';
import 'package:new_digivote/widgets/themes.dart';


class showcandidatedatapage extends StatefulWidget {
  const showcandidatedatapage({required this.ID,required this.docID,required this.name,required this.user_profile_url});
  final String ID;
  final String docID;
  final String name;
  final String user_profile_url;

  @override
  State<showcandidatedatapage> createState() => _showcandidatedatapageState();
}

class _showcandidatedatapageState extends State<showcandidatedatapage> {

  int flag=0;
  // String? id='';
  String name='Loading..';
  String user_name='';
  String party='Loading..';
  String position='Loading..';
  String count='0';
  String new_ID='';
  String new_docID='';
  String new_user_profile_url='';
  String URL='';
  // bool adddetails=false;
  // bool updatecount=false;

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
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).get().then((snapshot) {
      if(snapshot.exists){
        setState(() {
          name= snapshot.data()!['Name'];
          party= snapshot.data()!['Party'];
          position= snapshot.data()!['Position'];
          count= snapshot.data()!['Count'];
          URL=snapshot.data()!['Profile URL'];
        });
        flag=1;
        // initState();
      }
    });
  }

  void addUserDetails(String ID,String docID,String count,String name,String email,String finish) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection('$ID/election_voted/Voters').doc(FirebaseAuth.instance.currentUser?.uid).set(   //map means the brackets for .add see mitch koko video for reference
        {
          'Name' : name,
          'E-Mail': email,
          'Finish': finish,
        }).then((value) {
          Navigator.pop(context);
          updateCount(ID, docID, count);
    });
    // final userData = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); //if no name in doc() is given then automatically id will get generated
    // and we can access it by using userData.id
    // final json={
    //   'E-Mail': email,
    //   'National ID':nationalid,
    // };
    // await userData.set(json);
  }

  // void updateName(String ID,String doc,String name) async {
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
  //     'Name': name,
  //   })//.set(   //map means the brackets for .add see mitch koko video for reference
  //   // {
  //   //   'Status': name,
  //   //   // 'Party':party,
  //   // })
  //       .then((value) {
  //     Navigator.pop(context);
  //     showStatusMessage("Name updated Successfully.", Colors.green);
  //     getDataFromDatabase(ID, doc);
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.red);
  //   });
  // }
  //
  // void updateParty(String ID,String doc,String party) async {
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
  //     'Party': party,
  //   })//.set(   //map means the brackets for .add see mitch koko video for reference
  //   // {
  //   //   'Status': name,
  //   //   // 'Party':party,
  //   // })
  //       .then((value) {
  //     Navigator.pop(context);
  //     showStatusMessage("Name updated Successfully.", Colors.green);
  //     getDataFromDatabase(ID, doc);
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     showStatusMessage(error.toString(), Colors.red);
  //   });
  // }
  //
  void updateCount(String ID,String doc,String count) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
      'Count': count,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      // updatecount=true;
      showStatusMessage("Voted Successfully.", Colors.green);
      // getDataFromDatabase(ID, doc);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

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
    user_name=widget.name;
    new_user_profile_url=widget.user_profile_url;
    int intcount=int.parse(count);
    // print(new_ID);
    if(flag==0)
    {
      print("getdata");
      getDataFromDatabase(new_ID,new_docID);
    }else{
      print("moksh");
    }

    // getDataFromDatabase();
    print(new_ID);
    flag=1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Candidate Details",
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
                      Image.network(URL).image,
                      radius: 90,
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 25,
                  //   child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(100),
                  //         color: mytheme.prim),
                  //     // child: IconButton(
                  //     //   color: Colors.black,
                  //     //   icon: Icon(Icons.camera_alt),
                  //     //   onPressed: () {},
                  //     // ),
                  //   ),
                  // )
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
                    "Party Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(party,
                    // "BJP",
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
                leading: Icon(Icons.label_outline),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Position",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(position,
                    // "Persident",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
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
                    intcount++;
                    // updateCount(new_ID, new_docID, intcount.toString());
                    // addUserDetails(new_ID, new_docID, intcount.toString(),user_name, FirebaseAuth.instance.currentUser!.email!, "voted"); //was used else comment
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => verifyfacepage(ID: new_ID, docID: new_docID, count: intcount.toString(), name: user_name, email: FirebaseAuth.instance.currentUser!.email!, finish: "voted",voter_profile_url: new_user_profile_url,)));
                    // if(adddetails && updatecount)
                    //   {
                    //     showStatusMessage("Voted Successfully.", Colors.green);
                    //   }

                    // electionId=electionID.text.trim();
                    // exists(electionId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          " Vote",
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

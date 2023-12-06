import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/Face.dart';
import 'package:new_digivote/RecyclerTest.dart';
import 'package:new_digivote/User.dart';
import 'package:new_digivote/final_face.dart';
import 'package:new_digivote/final_match.dart';
import 'package:new_digivote/new_face.dart';
import 'package:random_string/random_string.dart';

class testpage extends StatefulWidget {
  const testpage({Key? key}) : super(key: key);

  @override
  State<testpage> createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  // String random=randomAlphaNumeric(8);
  // final user=FirebaseAuth.instance.currentUser!;
  // String? id='';
  int flag=0;
  // late String id;

  @override
  void initState() {
    // if(flag==0) {
    //   getDataFromDatabase();
    // }else {
    //   verifyDataFromDatabase();
    // }

    //   print("True");
    // }else {
    //   print("False");
    // }

    super.initState();
  }

  // Future getDataFromDatabase() async {
  //   await FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((snapshot) {
  //     if(snapshot.exists){
  //       setState(() {
  //         id= snapshot.data()!['National ID'];
  //         flag=1;
  //       });
  //       initState();
  //     }
  //   });
  // }
  //
  // Future verifyDataFromDatabase() async {
  //   if(await id=="001"){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Testing Condtition in init successfull. ${id}"),
  //       // duration: Duration(seconds: 2, milliseconds: 500),
  //       backgroundColor: Colors.black,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //     ),
  //     ); //showSnackBar
  //   }else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Testing Condtition in init NOT successfull. ${id} hello"),
  //       // duration: Duration(seconds: 2, milliseconds: 500),
  //       backgroundColor: Colors.black,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //     ),
  //     );
  //   }
  //   flag=0;
  //   // await FirebaseFirestore.instance.collection('Users').doc(user.uid).get().then((snapshot) {
  //   //   if(snapshot.exists){
  //   //     setState(() {
  //   //       id= snapshot.data()!['National ID'];
  //   //     });
  //   //   }
  //   // });
  // }

  // Stream<QuerySnapshot> get users{
  //   return FirebaseFirestore.instance.collection('Users').snapshots(); //usercollection=FirebaseFirestore.instance.collection('Users')
  // }
  //
  // Future getCurrentUserData() async {  //future
  //   try{
  //     DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
  //     String data = ds.get('National ID');
  //     return data;
  //   }catch(e) {
  //     print(e.toString());
  //   }
  // }

  //document IDs
  // List<String> docIDs=[];
  //
  // Future getDocID() async {
  //   await FirebaseFirestore.instance.collection('Users').doc(user.uid).get({
  //
  //   });
  // }

  // Stream<List<UserModel>> readUsers() => FirebaseFirestore.instance.collection('Users')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  //
  // Widget buildUser(UserModel model) => ListTile(
  //   title: Text('{model.nationalid}'),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Page"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("LOGGED IN AS: " + user.email!),
              // Text("Data: "+id!),
              ElevatedButton(
                  child: Text('Recycler Page'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => recyclerlist()));
                  }
              ),
              ElevatedButton(
                  child: Text('Face Page'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => finalmatchpage()));
                  }
              ),
              // StreamBuilder<List<UserModel>>(
              //   stream: readUsers(),
              //     builder: (context,snapshot) {
              //     if(snapshot.hasError) {
              //       return Text("Something went wrong! ${snapshot.error}" );
              //     }else if(snapshot.hasData) {
              //       final users = snapshot.data!;
              //       return ListView(
              //         children: users.map(buildUser).toList(),
              //       );
              //     }else {
              //       return Center(child: Text("In line 57 of test.dart"),);
              //     }
              //
              //     }),
            ],
          )
      ),
    );
  }
}

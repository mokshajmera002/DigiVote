import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class GetUserName extends StatelessWidget {
  const GetUserName({required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context) {
    //get collection
    CollectionReference users= FirebaseFirestore.instance.collection('53G4VE27/election_admin/Candidates');
    if(documentId==null)
      {
        return Text("Empty");
      }else{
      return FutureBuilder <DocumentSnapshot>(
          future: users.doc(documentId).get(),
          builder: ((context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              Map<String,dynamic> data= snapshot.data!.data() as Map<String,dynamic>;
              return Text('${data['Name']}',style: context.titleMedium,textScaleFactor: 1.1,textAlign: TextAlign.left);
            }
            return Text("LOADING .....");
          })
      );
    }

    // return FutureBuilder <DocumentSnapshot>(
    //   future: users.doc(documentId).get(),
    //     builder: ((context,snapshot) {
    //       if(snapshot.connectionState == ConnectionState.done) {
    //         Map<String,dynamic> data= snapshot.data!.data() as Map<String,dynamic>;
    //         return Text('${data['Name']}',style: context.titleMedium,textScaleFactor: 1.1,textAlign: TextAlign.left,);
    //       }
    //       return Text("LOADING .....");
    //     })
    // );
  }
}

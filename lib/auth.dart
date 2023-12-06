import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/login.dart';
import 'package:new_digivote/home.dart';
import 'package:new_digivote/signup.dart';
import 'package:new_digivote/verify.dart';

class authpage extends StatelessWidget {
  const authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return verifypage();  //verifypage  //homepage
          }else {
            return loginpage();  // signuppage   //loginpage
          }
        }
      ),
    );
  }
}
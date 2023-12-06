import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/home.dart';
import 'package:new_digivote/login.dart';

class verifypage extends StatefulWidget {
  const verifypage({Key? key}) : super(key: key);

  @override
  State<verifypage> createState() => _verifypageState();
}

class _verifypageState extends State<verifypage> {
  User? user = FirebaseAuth.instance.currentUser;  //another video
  bool isEmailVerified=false;
  final auth=FirebaseAuth.instance;
  // var user;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // user=auth.currentUser;
    if(!(user!.emailVerified))//another video
      {
        auth.currentUser?.sendEmailVerification().onError((error, stackTrace) {
          showStatusMessage(error.toString(), Colors.red);
        });
      }
    // auth.currentUser?.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 25), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      showStatusMessage("E-Mail Verified Successfully.", Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => HomePage())));  //HomePage
      // Navigator.pop(context);

      timer?.cancel();
    }else {
      showStatusMessage("Kindly verify your E-Mail.", Colors.lightBlueAccent);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Kindly wait till your email is verified.',//'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      auth.currentUser?.sendEmailVerification().onError((error, stackTrace) {
                        showStatusMessage(error.toString(), Colors.red);
                      }).then((value) {
                        showStatusMessage("E-Mail Resent Successfully.", Colors.green);});
                      // FirebaseAuth.instance.currentUser
                      //     ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

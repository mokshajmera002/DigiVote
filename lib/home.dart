import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/login.dart';
import 'package:new_digivote/test.dart';


class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final user=FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );



    FirebaseAuth.instance.signOut().then((value) {
      // pop the loading circle
      Navigator.pop(context);
      //showing message in snackbar
      showStatusMessage('Log-Out Successfull.', Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => loginpage())));
    });

    //navigating to loginpage
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => loginpage())));
    // Navigator.pop(context);
    // return true;
  }

  //shows status in snackbar
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
    return WillPopScope(
        onWillPop: () async {
          final value =await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('DigiVote',style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  content: Text('Do you want to LOGOUT of DigiVote?'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop(false);
                      }, child: Text('No')),
                    TextButton(onPressed: () {
                      // test=signUserOut();
                      signUserOut();
                      Navigator.of(context).pop(true);
                    }, child: Text(
                              'Yes',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                // color: Colors.green,
                                // fontSize: 35,
                                ),
                          ),
                    ),
                  ],
                );
              });
          if(value!=null)
            {
              return Future.value(value);
            }else {
            return Future.value(false);
          }
        },
    child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.power_settings_new_rounded,color: Colors.white,)  //power_settings_new_rounded
          )
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("LOGGED IN AS: "+user.email!),
              ElevatedButton(
                  child: Text('Test Page'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => testpage()));
                  }
              )
            ],
          )
      ),
    ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_digivote/signup.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:new_digivote/widgets/themes.dart';

class forgot_pass extends StatefulWidget {
  const forgot_pass({super.key});

  @override
  State<forgot_pass> createState() => _forgot_passState();
}

class _forgot_passState extends State<forgot_pass> {
  bool _isObscure = true;
  bool _isObscure1 = true;
  final emailcontroller=TextEditingController();

  void dispose(){
    emailcontroller.dispose();
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

  Future passwordReset() async{
    //show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    if(emailcontroller.text != null)
    {
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text.trim()).then((value) {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage("Password reset link sent! Check your E-Mail.",mytheme.prim);
        });
      }on FirebaseAuthException catch(e) {
        if(e.code=='invalid-email')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Invalid E-mail.',Colors.red);
        }else if(e.code=='unknown')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Kindly Fill all the Fields.',Colors.red);
        }else if(e.code=='user-not-found')
        {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage('Account does not exists.\nKindly sign-up to continue.',Colors.red);
          Navigator.push(context, MaterialPageRoute(builder: (_) => signuppage()));
        }else {
          //pop the loading circle
          Navigator.pop(context);
          //show error message
          showStatusMessage(e.code, Colors.red);
        }
      }
    }else {
      showStatusMessage("Kindly enter all Fields.", Colors.redAccent);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Reset Password",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Card(
        // color: Colors.white,
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Image.asset("lib/assets/images/forget_pass.png"),
                SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    "Create a new password",
                    textAlign: TextAlign.start,
                    textScaleFactor: 1.3,
                    style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Text(
                    "Your new password must be different",
                    textAlign: TextAlign.start,
                    textScaleFactor: 1.3,
                    style: context.captionStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 10),
                  child: Text(
                    "from previous used passwords.",
                    textAlign: TextAlign.start,
                    textScaleFactor: 1.3,
                    style: context.captionStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailcontroller,
                    // obscureText: _isObscure,
                    decoration: InputDecoration(
                      // labelText: "Username",
                        labelStyle: TextStyle(color: mytheme.prim),
                        hintText: "Enter the email address",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mytheme.prim),
                            borderRadius:
                            BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(15))),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: mytheme.prim,
                        ),
                        // suffixIcon: IconButton(
                        //   icon: Icon(_isObscure
                        //       ? Icons.visibility
                        //       : Icons.visibility_off),
                        //   onPressed: () {
                        //     setState(() {
                        //       _isObscure = !_isObscure;
                        //     });
                        //   },
                        //   color: mytheme.prim,
                        // )
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(10),
                //   child: TextFormField(
                //     // controller: useridcontroller,
                //     obscureText: _isObscure1,
                //     decoration: InputDecoration(
                //         // labelText: "Username",
                //         labelStyle: TextStyle(color: mytheme.prim),
                //         hintText: "Confirm new password",
                //         focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: mytheme.prim),
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(15))),
                //         border: OutlineInputBorder(
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(15))),
                //         prefixIcon: Icon(
                //           Icons.lock_outline_rounded,
                //           color: mytheme.prim,
                //         ),
                //         suffixIcon: IconButton(
                //           icon: Icon(_isObscure1
                //               ? Icons.visibility
                //               : Icons.visibility_off),
                //           onPressed: () {
                //             setState(() {
                //               _isObscure1 = !_isObscure1;
                //             });
                //           },
                //           color: mytheme.prim,
                //         )),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(1000, 50),
                          backgroundColor: mytheme.prim,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          shadowColor: Colors.black,
                          // overlayColor:
                          //     MaterialStateColor.resolveWith((states) => Colors.cyan),
                        ),
                        onPressed: () {
                         passwordReset();
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 20,
                            backgroundColor: Colors.transparent,
                          ),
                        )),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

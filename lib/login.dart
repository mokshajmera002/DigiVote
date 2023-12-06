import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_digivote/HomePage.dart';
import 'package:new_digivote/forgot_password.dart';
import 'package:new_digivote/home.dart';
import 'package:new_digivote/signup.dart';
import 'package:new_digivote/signup_first.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final email=TextEditingController();
  final password=TextEditingController();

  void signUserIn() async
  {
    //show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    try
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
        Navigator.pop(context);
        showStatusMessage("Log-In Successfully.",mytheme.prim);
      });

      // pop the loading circle
      // Navigator.pop(context);
      // showStatusMessage("Log-In Successfully.",mytheme.prim);

      // homepage();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));  //in reality take HomePage

    }on FirebaseAuthException catch(e)
    {
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
      }else if(e.code=='wrong-password')
      {
        //pop the loading circle
        Navigator.pop(context);
        //show error message
        showStatusMessage('Kindly enter correct password.',Colors.red);
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
  }

  //shows status message in snackbar
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

  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
        color: Colors.white,
        child: ListView(
          // scrollDirection: Axis.vertical,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset("lib/assets/images/login2.jpg"),
                  SizedBox(
                    height: 17,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Text(
                      "Welcome back!",
                      textAlign: TextAlign.start,
                      textScaleFactor: 1.5,
                      style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 10),
                    child: Text(
                      "Let's Login to explore continues",
                      textAlign: TextAlign.start,
                      textScaleFactor: 1.4,
                      style: context.captionStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        controller: email,
                        // validator: ,
                        decoration: InputDecoration(
                          // labelText: "Username",
                          labelStyle: TextStyle(color: mytheme.prim),
                          focusedBorder: OutlineInputBorder(
                            // borderSide:
                            //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                              borderSide: BorderSide(color: mytheme.prim),
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: mytheme.prim,
                          ),
                          hintText: "Enter your email",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: password,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        // labelText: "Username",
                          labelStyle: TextStyle(color: mytheme.prim),
                          hintText: "Enter your password",
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
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            color: mytheme.prim,
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => forgot_pass()))
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot password?",
                            style: TextStyle(color: Vx.gray400),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                            signUserIn();
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 20,
                              backgroundColor: Colors.transparent,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    splashColor: Colors.white,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signupfirstpage())),
                      // Navigator.pop(context)
                    },
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an Account?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " Sign up here",
                              style: TextStyle(color: mytheme.prim, fontSize: 16),
                            )
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

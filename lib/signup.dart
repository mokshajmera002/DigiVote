import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_digivote/login.dart';
import 'package:new_digivote/verify.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class signuppage extends StatefulWidget {
  const signuppage({super.key});

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  final emailController=TextEditingController();
  final nationalId=TextEditingController();
  final passwordController=TextEditingController();
  final confirmpasswordController=TextEditingController();

  void dispose() {
    emailController.dispose();
    nationalId.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }


  void signUserUp() async
  {
    if(nationalId.text != '' && passwordController.text != '' && emailController.text != '')
      {
        //show loading circle
        showDialog(context: context, builder: (context)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        );

        if(passwordController.text!=confirmpasswordController.text )
        {
          Navigator.pop(context);
          showStatusMessage("Passwords don't match.",Colors.red);
          return;
        }

        //try creating the user
        try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
            addUserDetails(emailController.text, nationalId.text);
            //pop the loading circle
            Navigator.pop(context);
            showStatusMessage("Account Created Successfully and email sent.",Colors.green);
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => verifypage())));
          // Navigator.pop(context);


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
          }else if(e.code=='weak-password')
          {
            //pop the loading circle
            Navigator.pop(context);
            //show error message
            showStatusMessage('Kindly make strong password.',Colors.red);
          }else if(e.code=='email-already-in-use')
          {
            //pop the loading circle
            Navigator.pop(context);
            //show error message
            showStatusMessage('Account already Exists.',Colors.greenAccent);
          }else {
            //pop the loading circle
            Navigator.pop(context);
            //show error message
            showStatusMessage(e.code, Colors.red);
          }
        }
      }else{
      showStatusMessage('Kindly fill all fields.', Colors.deepOrangeAccent);
    }
  }

  void addUserDetails(String email,String nationalid) async {
    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).set(   //map means the brackets for .add see mitch koko video for reference
        {
          'E-Mail': email,
          'National ID':nationalid,
        });
    // final userData = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); //if no name in doc() is given then automatically id will get generated
    // and we can access it by using userData.id
    // final json={
    //   'E-Mail': email,
    //   'National ID':nationalid,
    // };
    // await userData.set(json);
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

  bool _isObscure = true;
  bool _isObscurecnf = true;
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            Image.asset("lib/assets/images/Sign up-amico1.png"),
            SizedBox(
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text(
                "Let's Get Started",
                textAlign: TextAlign.start,
                textScaleFactor: 1.5,
                style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 10),
              child: Text(
                "Create an account to get all features",
                textAlign: TextAlign.start,
                textScaleFactor: 1.2,
                style: context.captionStyle,
              ),
            ),
            // SizedBox(
            //   height: 2,
            // ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,

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
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: nationalId,

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
                    Icons.perm_identity_rounded,
                    color: mytheme.prim,
                  ),
                  hintText: "Enter your national ID",
                    errorText: _validate ? 'Value Cannot Be Empty' : null,
                ),
                // validator: (value){
                //   if(value!.isEmpty)
                //   {
                //     return 'Please fill.';
                //   }else{
                //     return null;
                //   }
                // }, //validator
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  // labelText: "Username",
                    labelStyle: TextStyle(color: mytheme.prim),
                    hintText: "Enter your password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mytheme.prim),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: mytheme.prim,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      color: mytheme.prim,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: confirmpasswordController,
                obscureText: _isObscurecnf,
                decoration: InputDecoration(
                  // labelText: "Username",
                    labelStyle: TextStyle(color: mytheme.prim),
                    hintText: "Confirm your password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mytheme.prim),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: mytheme.prim,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscurecnf
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscurecnf = !_isObscurecnf;
                        });
                      },
                      color: mytheme.prim,
                    )),
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
                      signUserUp();

                      },
                    child: Text(
                      "Sign Up",
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
                    MaterialPageRoute(builder: (context) => loginpage()))
              },
              child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Login here.",
                        style: TextStyle(color: mytheme.prim, fontSize: 16),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

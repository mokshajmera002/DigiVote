import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_digivote/result.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class getresultid extends StatefulWidget {
  const getresultid({super.key});

  @override
  State<getresultid> createState() => getresultidState();
}

class getresultidState extends State<getresultid> {
  final _formkey = GlobalKey<FormState>();
  final electionID=TextEditingController();
  String status='';
  String getstatus='';

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

  Future<String> getDataFromDatabaseForResults(String ID) async {
    String answer="NA";
    // showDialog(context: context, builder: (context)
    // {
    //   return const Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // },
    // );
    await FirebaseFirestore.instance.collection(ID).doc("election_admin").get().then((snapshot) {
      print(snapshot.exists);
      if(snapshot.exists){
        // print("Yes");
        setState(() {
          status= snapshot.data()!['Status'];
          answer=status;
          // party= snapshot.data()!['Party'];
        });
        // Navigator.pop(context);
        // flag=1;
        // initState();
      }else{
        answer="NE";
      }
    });
    return answer;
  }

  void viewResults(String ID) async{
    // show loading circle
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      );
    },
    );
    final snapshot = await FirebaseFirestore.instance.collection(ID).get();
    if ( snapshot.size == 0 ) {
      Navigator.pop(context);
      showStatusMessage("ID does not Exists.", Colors.orange);
      print('Collection does not exist');
    }else {
      Future<String> stringFuture = getDataFromDatabaseForResults(ID);
      // Navigator.pop(context);
      getstatus= await stringFuture;//getDataFromDatabase(ID).toString();
      if(getstatus=="Stop")
      {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => resultpage(ID: ID,flag: "0",))));
      }else{
        Navigator.pop(context);
        showStatusMessage("Result will get displayed once Voting is stopped.", Colors.pinkAccent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Get Result ID",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 10),
            child: Center(
              child: Text(
                "Enter the Election ID",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 5, 20),
            child: Container(
              child: Text(
                "DigiVote manages your elections by their unique Ids. Please enter the 8 digit unique Id to explore continues",
                style: context.captionStyle,
                textScaleFactor: 1.05,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Form(
                    key: _formkey,
                    child: Container(
                      height: 82,
                      child: TextFormField(
                        controller: electionID,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
                          } else if (value.length < 8) {
                            return "Field cannot be short than 8 characters";
                          }
                          setState(() {

                          });
                        },
                        decoration: InputDecoration(
                          // filled: true,
                          // labelText: "Username",
                          labelStyle: TextStyle(color: mytheme.prim),
                          focusedBorder: OutlineInputBorder(
                            // borderSide:
                            //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                              borderSide: BorderSide(color: mytheme.prim),
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => forgot_pass()));
                            },
                            color: mytheme.prim,
                            icon: Icon(
                              Icons.qr_code_scanner_sharp,
                            ),
                            iconSize: 31,
                          ),
                          hintText: "Enter Election Id here...",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                      if(_formkey.currentState!.validate())
                      {
                        viewResults(electionID.text.trim());
                      }

                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            " Submit",
                            style: TextStyle(
                              fontSize: 25,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Icon(Icons.arrow_right),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

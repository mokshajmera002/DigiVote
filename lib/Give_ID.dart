import 'package:flutter/material.dart';
import 'package:new_digivote/GenerateQR.dart';
import 'package:new_digivote/Get_Manage_ID.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class giveElectionIDpage extends StatefulWidget {
  const giveElectionIDpage({required this.ID});
  final String ID;

  @override
  State<giveElectionIDpage> createState() => _giveElectionIDpageState();
}

class _giveElectionIDpageState extends State<giveElectionIDpage> with SingleTickerProviderStateMixin  {
  late AnimationController controller;
  // String random=randomAlphaNumeric(8);

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


  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

//   ElevatedButton(
//   child: Text('Copy to Clipboard'),
//   onPressed: () async {
//   await Clipboard.setData(ClipboardData(text:random)).then((value) {
//   showStatusMessage("Copied to Clipboard", Colors.grey);
//   });
// }
// )

  @override
  Widget build(BuildContext context) {
    String random=widget.ID;
    return Scaffold(
      appBar: AppBar(
        title: Text("Election ID",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: mytheme.prim,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => generateqrpage(ID: random))); //generateqrpage(random)
              },
              icon: Icon(Icons.qr_code_2_rounded,color: Colors.black,)  //power_settings_new_rounded
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: 300,
              // color: Colors.black,
              child: Lottie.asset("lib/assets/animations/lottie_tick.json",
                  height: 250, controller: controller, onLoaded: (composition) {
                    controller.forward();
                  }),
            ),
            Center(
                child: Text(
                  "Election is Successfully generated.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: SizedBox(
                height: 230,
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 70, 25),
                        child: Text(
                          "Please Note the below information:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 205, 0),
                        child: Text(
                          "Name of election",
                          style: context.captionStyle,
                          textScaleFactor: 1.3,
                        ),
                      ),
                      ListTile(
                        title: Text(random,
                          // "7EWf8EvU",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.red),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.copy_outlined),
                          onPressed: () async{
                              await Clipboard.setData(ClipboardData(text:random)).then((value) {
                              showStatusMessage("Copied to Clipboard", Colors.grey);
                            });
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Text(
                          "The Above code is election code and is required for all tasks related to this election.",
                          style: context.captionStyle,
                          textScaleFactor: 1.1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => getmanageidpage(flag: "0",)));
                //please give the path to manage election from here
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 50, 20, 10),
                child: Row(
                  children: [
                    Text(
                      "Want to Manage Election?",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      " Manage here.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mytheme.prim,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

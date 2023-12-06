import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_digivote/widgets/themes.dart';


class managecandidatedatapage extends StatefulWidget {
  const managecandidatedatapage({required this.ID,required this.docID});
  final String ID;
  final String docID;

  @override
  State<managecandidatedatapage> createState() => _managecandidatedatapageState();
}

class _managecandidatedatapageState extends State<managecandidatedatapage> {

  int flag=0;
  // String? id='';
  String name='Loading..';
  String party='Loading..';
  String position='Loading..';
  String new_ID='';
  String new_docID='';

  final namecontroller=TextEditingController();
  final partycontroller=TextEditingController();
  final positioncontroller=TextEditingController();

  // void initState() {
  //   super.initState();
  //   getDataFromDatabase(new_ID,new_docID);
  // }

  // void loading() {
  //   //show loading circle
  //   showDialog(context: context, builder: (context)
  //   {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   },
  //   );
  //   getDataFromDatabase();
  //   //pop the loading circle
  //   Navigator.pop(context);
  //   showStatusMessage("Data fetched.",Colors.green);
  // }

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

  Future getDataFromDatabase(String ID,String doc) async {
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).get().then((snapshot) {
      if(snapshot.exists){
        setState(() {
          name= snapshot.data()!['Name'];
          party= snapshot.data()!['Party'];
          position= snapshot.data()!['Position'];
        });
        flag=1;
        // initState();
      }
    });
  }

  void updateName(String ID,String doc,String name) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
      'Name': name,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("Name updated Successfully.", Colors.green);
      getDataFromDatabase(ID, doc);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  void updateParty(String ID,String doc,String party) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
      'Party': party,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("Name updated Successfully.", Colors.green);
      getDataFromDatabase(ID, doc);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  void updatePosition(String ID,String doc,String position) async {
    showDialog(context: context, builder: (context)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    await FirebaseFirestore.instance.collection("$ID/election_admin/Candidates").doc(doc).update({
      'Position': position,
    })//.set(   //map means the brackets for .add see mitch koko video for reference
    // {
    //   'Status': name,
    //   // 'Party':party,
    // })
        .then((value) {
      Navigator.pop(context);
      showStatusMessage("Name updated Successfully.", Colors.green);
      getDataFromDatabase(ID, doc);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => manageelectionpage(ID: new_ID)));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showStatusMessage(error.toString(), Colors.red);
    });
  }

  // void showAlertDialog(BuildContext context){
  //   Widget Save= E
  // }

  // new_ID=widget.ID;
  // new_docID=widget.docID;
  // // print(new_ID);
  // if(flag==0)
  // {
  // print("getdata");
  // getDataFromDatabase(new_ID,new_docID);
  // }else{
  // print("moksh");
  // }
  //
  // // getDataFromDatabase();
  // print(new_ID);
  // flag=1;

  @override
  Widget build(BuildContext context) {
    new_ID=widget.ID;
    new_docID=widget.docID;
    // print(new_ID);
    if(flag==0)
    {
      print("getdata");
      getDataFromDatabase(new_ID,new_docID);
    }else{
      print("moksh");
    }

    // getDataFromDatabase();
    print(new_ID);
    flag=1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mytheme.prim,
        title: Text(
          "Candidate Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
              child: Stack(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(
                      // eccentricity: 0.2,
                        side: BorderSide(color: Colors.black, width: 2)),
                    child: CircleAvatar(
                      backgroundImage:
                      AssetImage("lib/assets/images/demo_profile.jpeg"),
                      radius: 90,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 25,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: mytheme.prim),
                      child: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(name,
                    // "Raj Ganatra",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      namecontroller.text=name;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter new name',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: namecontroller,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: name,
                                ),
                                // initialValue: name,
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updateName(new_ID, new_docID, namecontroller.text.trim()); // namecontroller.text.trim()
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
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
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ListTile(
                leading: Icon(Icons.group),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Party Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(party,
                    // "BJP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      partycontroller.text=party;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter new party name',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: partycontroller,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: party,
                                ),
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updateParty(new_ID, new_docID, partycontroller.text.trim());
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
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
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ListTile(
                leading: Icon(Icons.label_outline),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Position",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(position,
                    // "Persident",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: mytheme.darkcreme,
                    onPressed: () {
                      positioncontroller.text=position;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(

                              title: Text('Enter new position',style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              content: TextFormField(
                                controller: positioncontroller,
                                decoration: InputDecoration(
                                  filled: true,
                                  // labelText: "Username",
                                  labelStyle: TextStyle(color: mytheme.prim),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide:
                                    //     BorderSide(color: Color.fromARGB(255, 16, 121, 174)),
                                      borderSide: BorderSide(color: mytheme.prim),
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  // hintText: position,
                                ),
                              ),//Text('Do you want to LOGOUT of DigiVote?'),
                              actions: [
                                // ElevatedButton(onPressed: () {}, child: Text("Button")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text('Cancel')),
                                TextButton(onPressed: () {
                                  // test=signUserOut();
                                  updatePosition(new_ID, new_docID, positioncontroller.text.trim());
                                  Navigator.of(context).pop(true);
                                }, child: Text(
                                  'Save',
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
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

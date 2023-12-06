import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class tile extends StatefulWidget {
  const tile({super.key});

  @override
  State<tile> createState() => _tileState();
}

class _tileState extends State<tile> {
  var vote = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              onTap: () {
                print("object");
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage:
                AssetImage("lib/assets/images/demo_profile.jpeg"),
              ),
              iconColor: Colors.black,
              title: Text("Moksh Ajmera", style: context.titleLarge),
              subtitle: Text(
                "mca@gmail.com",
                style: context.captionStyle,
                textScaleFactor: 1.1,
              ),
              trailing: Text(
                "$vote Vote(s)",
                textScaleFactor: 1.1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
//Image.asset("lib/assets/images/demo_profile.jpeg")

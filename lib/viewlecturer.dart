import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

String lecturer_id, lecturer_name;
bool hasdata = true;
Map<dynamic, dynamic> exist;
Iterable<dynamic> key_id, data;
Widget body;
List<User> allData = new List();

final FirebaseDatabase database = FirebaseDatabase.instance;

class viewlecturer extends StatefulWidget {
  viewlecturer({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _viewlecturerState createState() => _viewlecturerState();
}

class User {
  String name, image;
  String score;

  User(this.name, this.score, this.image);

  @override
  String toString() {
    return '{ ${this.name}, ${this.score},${this.image}  }';
  }
}

class _viewlecturerState extends State<viewlecturer> {
  @override
  void initState() {
    print("hello");

    this.get_data();
  }

  @override
  Widget build(BuildContext context) {
    if (hasdata == false) {
      body = new Container(
          child: Center(
        child: Text(
          "data not EXIST",
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ));
    }
    if (hasdata == true) {
      body = new Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: exist == null ? 0 : exist.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              //
              //                           if(<-- Card widget

              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(exist.values.toList()[index]["image"]),
                ),
                /* Image.network(
                  exist.values.toList()[index]["image"],
                ),*/
                title: Text(exist.values.toList()[index]["name"],
                    style: TextStyle(fontSize: 15, color: Color(0xfffbb448))),
                subtitle: Text(
                    "Score" +
                        " : " +
                        exist.values.toList()[index]["score"].toString(),
                    style: TextStyle(fontSize: 12, color: Color(0xfffbb448))),
              ),
            );
          },
        ),
      );
    }

    return body;
  }

  Future<String> get_data() async {
    database
        .reference()
        .child("")
        .orderByChild("score")
        .once()
        .then((DataSnapshot snapshot) async {
      this.setState(() {
        exist = snapshot.value;
        exist.removeWhere((key, value) => key == "Videos");
      });

      if (exist == null) {
        setState(() {
          hasdata = false;
        });

        // confirmation();
      } else if (exist != null) {
        setState(() {
          hasdata = true;

          key_id = exist.keys;
          data = exist.values;
        });
      }
    });
  }
}

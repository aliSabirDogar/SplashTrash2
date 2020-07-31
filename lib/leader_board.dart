import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class leader_board extends StatefulWidget {
  leader_board({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ScoreBoard createState() => ScoreBoard();
}

class User {
  String name, image;
  int score;

  User(this.name, this.score, this.image);

  @override
  String toString() {
    return '{ ${this.name}, ${this.score},${this.image}  }';
  }
}

class ScoreBoard extends State<leader_board> {
  List<User> allData = new List();
  var superheros_length;
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'ListViews',
      theme: ThemeData(
          // primarySwatch: Color(0xfffbb448),
          ),
      home: Scaffold(
        // appBar: AppBar(title: Text('Leader Board')),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  final ref = FirebaseDatabase.instance;
//

  List<User> allData = [];

  return ListView.builder(
    itemCount: allData == null ? 0 : allData.length,
    itemBuilder: (context, index) {
      return Card(
        //
        //                           if(<-- Card widget

        child: ListTile(
          leading: Image.network(
            allData[index].image.toString(),
          ),
          title: Text(allData[index].name.toString(),
              style: TextStyle(fontSize: 15, color: Color(0xfffbb448))),
          subtitle: Text("Score" + " : " + allData[index].score.toString(),
              style: TextStyle(fontSize: 12, color: Color(0xfffbb448))),
        ),
      );
    },
  );
  return ListView();
}

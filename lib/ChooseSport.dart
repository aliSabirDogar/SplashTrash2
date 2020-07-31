import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashtrash/HomeScreen.dart';
import 'package:splashtrash/signup.dart';

class ChooseSport extends StatefulWidget {
  ChooseSport({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChooseSport createState() => _ChooseSport();
}

class _ChooseSport extends State<ChooseSport> {
  final fb = FirebaseDatabase.instance;
  var ref = null;

  Future<void> initDeviceId() async {
    String imei;
    String meid;
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
  }

  var key, value;
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
        action:
            SnackBarAction(label: key, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget sport1() {
    return InkWell(
        onTap: () {},
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Color(0xfffbb448)),
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Colors.white, // Color pinkAccent
          child: Row(
            // Add a Row Widget for placing objects.
            mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
            mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0), // Give to the text some space.
                child: Text(
                  "Basketball",
                  style: TextStyle(
                    fontSize: 18, // 18pt in font.
                    color: Color(
                        0xfffbb448), // You can ommit it if you use textColor in RaisedButton.
                  ),
                ),
              ),
              Image.asset(
                'assets/videos/basketball.jpg',
                width: 25,
                height: 25,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen('basketball');
            }));
          },

          /// For enabling the button
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget other() {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("other")));
        },
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Color(0xfffbb448)),
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Colors.white, // Color pinkAccent
          child: Row(
            // Add a Row Widget for placing objects.
            mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
            mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0), // Give to the text some space.
                child: Text(
                  "other ",
                  style: TextStyle(
                    fontSize: 18, // 18pt in font.
                    color: Color(
                        0xfffbb448), // You can ommit it if you use textColor in RaisedButton.
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen('baseball');
            }));
          },

          /// For enabling the button
        ));
  }

  Widget sport4() {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("soccer")));
        },
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Color(0xfffbb448)),
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Colors.white, // Color pinkAccent
          child: Row(
            // Add a Row Widget for placing objects.
            mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
            mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0), // Give to the text some space.
                child: Text(
                  "soccer",
                  style: TextStyle(
                    fontSize: 18, // 18pt in font.
                    color: Color(
                        0xfffbb448), // You can ommit it if you use textColor in RaisedButton.
                  ),
                ),
              ),
              Image.asset(
                'assets/videos/soccer.png',
                width: 25,
                height: 25,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen('soccer');
            }));
          },

          /// For enabling the button
        ));
  }

  Widget sport3() {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("baseball")));
        },
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Color(0xfffbb448)),
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Colors.white, // Color pinkAccent
          child: Row(
            // Add a Row Widget for placing objects.
            mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
            mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0), // Give to the text some space.
                child: Text(
                  "Baseball ",
                  style: TextStyle(
                    fontSize: 18, // 18pt in font.
                    color: Color(
                        0xfffbb448), // You can ommit it if you use textColor in RaisedButton.
                  ),
                ),
              ),
              Image.asset(
                'assets/videos/baseball.png',
                width: 25,
                height: 25,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen('baseball');
            }));
          },

          /// For enabling the button
        ));
  }

  Widget sport2() {
    return InkWell(
        onTap: () {
          // UpdateScore();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen("football")));
        },
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Color(0xfffbb448)),
            borderRadius: new BorderRadius.circular(18.0),
          ),
          color: Colors.white, // Color pinkAccent
          child: Row(
            // Add a Row Widget for placing objects.
            mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
            mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0), // Give to the text some space.
                child: Text(
                  "Football  ",
                  style: TextStyle(
                    fontSize: 18, // 18pt in font.
                    color: Color(
                        0xfffbb448), // You can ommit it if you use textColor in RaisedButton.
                  ),
                ),
              ),
              Image.asset(
                'assets/videos/ruggby.jpg',
                width: 25,
                height: 25,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen('football');
            }));
          },

          /// For enabling the button
        ));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Choose Sport',
          style: GoogleFonts.mukta(
            decorationThickness: 20,

            //fontStyle: FontWeight.w500,
            //   textStyle: Theme.of(context).textTheme.display2,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ref = fb.reference();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          /*  Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),*/
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),

                  /*_emailPasswordWidget(),*/
                  SizedBox(height: 20),
                  sport1(),
                  SizedBox(height: 20),

                  //_divider(),
                  sport2(),
                  SizedBox(height: 20),
                  // _divider(),
                  sport3(),
                  SizedBox(height: 20),
                  sport4(),
                  SizedBox(height: 20),
                  other(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}

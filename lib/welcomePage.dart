import 'package:flutter/material.dart';
import 'package:splashtrash/loginPage.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _title() {
    return Image.asset('assets/videos/logo.jpg');
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(seconds: 4),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage())));

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/videos/logo.jpg',
              width: 270.0,
              height: 270.0,
            ),
          ),
        ],
      ),
    );
  }
}

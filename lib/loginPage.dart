import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashtrash/ChooseSport.dart';
import 'package:splashtrash/signup.dart';

import 'Widget/bezierContainer.dart';
import 'instagramLogin/instagram.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String name;

  Map userProfile;
  final FacebookLogin fbLogin = FacebookLogin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // StreamController
  final BehaviorSubject<String> _facebookResult = BehaviorSubject<String>();
  final BehaviorSubject<String> _userName = BehaviorSubject<String>();
  String flag;
  bool _isLoggedIn = false;

  // Streams
  Stream<String> get facebookToken => _facebookResult.stream;

  Stream<String> get userName => _userName.stream;

  // Function
  Function(String) get changeUserName => _userName.sink.add;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _saveData() async {
    final SharedPreferences prefs = await _prefs;
    // final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      prefs.setString('login', 'true');
      prefs.setString('name', name);
    });
  }

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        name = _googleSignIn.currentUser.displayName;
        _saveData();

        ref
            .child(_googleSignIn.currentUser.displayName)
            .child("name")
            .set(_googleSignIn.currentUser.displayName);
        ref.child(_googleSignIn.currentUser.displayName).child("score").set(0);
        ref
            .child(_googleSignIn.currentUser.displayName)
            .child("image")
            .set(_googleSignIn.currentUser.photoUrl);
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  sigInFacebook() async {
    fbLogin.logIn(['email']).then(
      (result) {
        switch (result.status) {
          case FacebookLoginStatus.loggedIn:
            {
              final token = result.accessToken.token;
              _facebookResult.sink.add(token);
              _getUserInfo(token).then(changeUserName);
              break;
            }
          case FacebookLoginStatus.error:
            {
              _facebookResult.addError("Facebook auth error");
              changeUserName('');
              break;
            }

          case FacebookLoginStatus.cancelledByUser:
            {
              _facebookResult.addError("Canceled by user");
              changeUserName('');
              break;
            }
        }
      },
    );
  }

  signOutFacebook() async {
    await fbLogin.logOut().then(_facebookResult.sink.add).then(changeUserName);
  }

  dispose() {
    _facebookResult.close();
    _userName.close();
  }

  Future<String> _getUserInfo(String accessToken) async {
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(200).height(200),first_name,last_name,email&access_token=$accessToken');
    final jsonResponse = json.decode(graphResponse.body);
    name = jsonResponse['name'];
    var url = jsonResponse["picture"]["data"]["url"];

    ref.child(jsonResponse['name']).child("name").set(jsonResponse['name']);
    ref.child(jsonResponse['name']).child("score").set(0);
    ref.child(jsonResponse['name']).child("image").set(url);
    name = jsonResponse['name'];
    _saveData();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseSport()));

    return jsonResponse['name'];
  }

  final fb = FirebaseDatabase.instance;
  var ref = null;
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

/*
  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
*/

  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          _login();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'Log in with Google',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
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

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void perform_login_insta() {
    String name2 = getRandString(6);
    //insta.getToken(constants.APP_ID, constants.APP_SECRET).then((token) {
    Token token;

    ref.child(name2).child("name").set(name2);
    ref.child(name2).child("score").set(0);
    ref
        .child(name2)
        .child("image")
        .set("https://img.icons8.com/fluent/48/000000/instagram-new.png");
    name = name2;
    _saveData();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseSport()));

    var success;
    // _view.onLoginScuccess(token);
    // });
  }

/*  Widget _instaButton() {
    return InkWell(
        onTap: () async {
          perform_login_insta();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(235, 9, 36, 5),
                    Color.fromRGBO(235, 9, 36, 5)
                  ])),
          child: Text(
            'Log in with Instagram',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ));
  }*/

  CheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('login');
    print(token);
    if (token == "true") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChooseSport()));
    } else {
      _showTermsDialog();
    }
  }

  void _showTermsDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        //context: _scaffoldKey.currentContext,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text("TERMS AND CONDITIONS ")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: 200,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    // Text('Name of requestor: }'),
                    Text(
                      '1. Definitions & Agreement to be bound \n 1.1 Definitions \n References to “you,” and/or “user” mean a user of the app. \n 1.2. Agreement to be bound \n The following Terms and Conditions, together with the relevant information set out on the app, including any features and services available, such as photographs, publications and other materials, are subject to the Terms and Conditions set forth below. Please read them carefully as any of use of the app constitutes an agreement, without acceptance, to be bound thereby by the User. By using the app and upon registration therefore, by clicking that you agree to these Terms, you represent that you are at least eighteen (18) years old, have read and understand the Terms and Conditions, and that you agree to be bound by these Terms and Conditions as set forth below.\n 2.  General Provisions\n 2.1. Nature\n The User agrees and acknowledges that, the app uses the points system for each right answer that is provided. You hereby agree that each right answer attracts 25 points and on the other hand you do not lose any points on any wrong answers given. In addition to that purchase points will be added to your total. For every video that a user uploads they will get 50 points.\n  2.2. Modifications and Changes to Terms and Conditions\n  We may modify, add to, suspend or delete these Terms and Conditions or other agreements, in whole or in part, in our sole discretion at any time, with such modifications, additions or deletions being immediately effective upon their posting to the app. We may additionally attempt to notify you of such changes by contacting you at the email you provided upon registration of an account or subscription. Your use of the app after modification, addition or deletion of these Terms and Conditions shall be deemed to constitute acceptance by you of the modification, addition or deletion.\n 3. Your Account \n You are responsible for any activity that occurs in your account. So it’s important that you keep your account secure. One way to do that is to select a strong password that you don’t use for any other account.\n  By using the Services, you agree that, in addition to exercising common sense:\n 	You will not create more than one account for yourself.',
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Agreed',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xFF121A21),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        //saveIssue();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: RaisedButton(
                        child: new Text(
                          'Disagree',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xFF121A21),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _facebookButton() {
    return InkWell(
        onTap: () async {
          sigInFacebook();
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff2872ba),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
//                  child: Text('f',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 25,
//                          fontWeight: FontWeight.w400)),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff2872ba),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Text('Log in with Facebook',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                ),
              ),
            ],
          ),
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
          text: 'SPLASH',
          style: GoogleFonts.mukta(
            decorationThickness: 20,

            //fontStyle: FontWeight.w500,
            //   textStyle: Theme.of(context).textTheme.display2,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'TRASH',
              style: TextStyle(color: Colors.black54, fontSize: 20),
            ),
            /*TextSpan(
              text: 'rnz',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),*/
          ]),
    );
  }

/*  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    ref = fb.reference();
    CheckLogin();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
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
                  SizedBox(height: 100),
                  /*_emailPasswordWidget(),*/
                  SizedBox(height: 20),
                  _submitButton(),

                  //_divider(),
                  _facebookButton(),
                  // _divider(),
                 // _instaButton(),
                  SizedBox(height: height * .055),
                  /*   _createAccountLabel(),*/
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

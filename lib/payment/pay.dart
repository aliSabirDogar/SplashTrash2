import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashtrash/payment/payment-service.dart';

class pay extends StatefulWidget {
  pay({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _pay createState() => _pay();
}

class _pay extends State<pay> {
  final fb = FirebaseDatabase.instance;
  var ref = null;
  String amount = '', earned_points = " ";
  Future<void> initDeviceId() async {
    String imei;
    String meid;
  }

  final FirebaseDatabase database = FirebaseDatabase.instance;
  @override
  void initState() {
    super.initState();
    //initDeviceId();
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

  showAlertDialogPoints(BuildContext context) {
    Widget cancelButton;
    Widget continueButton;
    Widget points;

    Wrap(
      spacing: 100,
      children: <Widget>[
        points = Text(
          'Congrats You Earned ' + earned_points + ' Points',
          style: TextStyle(fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
    // set up the buttons

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),

      /// backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
      actions: [
        points,
        SizedBox(
          height: 50,
        ),
        cancelButton,
        SizedBox(
          height: 50,
        ),
        continueButton,
        //   continueButton
      ],
    );

    // show the dialog

    UpdateScore() async {
      var token;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('name');
      print(token);
      database
          .reference()
          .child(token)
          .child("score")
          .once()
          .then((DataSnapshot snapshot) async {
        this.setState(() {
          String score = snapshot.value.toString();
          var myInt = int.parse(score);
          var earned = int.parse(earned_points);
          myInt = myInt + earned;

          final fb = FirebaseDatabase.instance;

          var ref = null;

          ref = fb.reference();

          ref.child(token).child("score").set(myInt);
        });
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            UpdateScore();
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          });
          return alert;
        });
  }

  payViaNewCard(BuildContext context) async {
    //String convertedamount = amount.toString();
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: amount, currency: 'USD');
    await dialog.hide();
    if (response.success == true) {
      showAlertDialogPoints(context);
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop(true);
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  Widget showAlertDialogPayment() {
    Widget cancelButton;
    Widget continueButton, pay1, pay2, pay3, pay4;
    Widget points, point2, point3, point4;
    Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Wrap(
          children: <Widget>[
            points = Align(
              alignment: Alignment.center,
              child: Text(
                ' .99c for a 100 points',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 50), // give it width
            pay1 = GradientButton(
              increaseWidthBy: 70,
              increaseHeightBy: 5,
              shapeRadius: BorderRadius.circular(18),
              callback: () {
                amount = '0.0099';
                earned_points = "100";
                // vc.play();
                // Navigator.pop(context);
                payViaNewCard(context);
              },
              gradient: Gradients.cosmicFusion,
              shadowColor: Gradients.cosmicFusion.colors.last.withOpacity(0.9),
              child: Text(
                'Pay',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),

            point2 = Align(
              alignment: Alignment.center,
              child: Text(
                ' 2.99c for 500 points',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50), // give it width
            pay2 = GradientButton(
              increaseWidthBy: 70,
              increaseHeightBy: 5,
              shapeRadius: BorderRadius.circular(18),
              callback: () {
                amount = '0.029900000000000003';
                earned_points = "500";
                //Navigator.pop(context);
                payViaNewCard(context);
              },
              gradient: Gradients.cosmicFusion,
              shadowColor: Gradients.cosmicFusion.colors.last.withOpacity(0.9),
              child: Text(
                'Pay',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),

            point3 = Align(
              alignment: Alignment.center,
              child: Text(
                '4.99c for 2000 points',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 50), // give it width
            pay3 = GradientButton(
              increaseWidthBy: 70,
              increaseHeightBy: 5,
              shapeRadius: BorderRadius.circular(18),
              callback: () {
                amount = '0.0499';
                earned_points = "2000";
                // Navigator.pop(context);
                payViaNewCard(context);
              },
              gradient: Gradients.cosmicFusion,
              shadowColor: Gradients.cosmicFusion.colors.last.withOpacity(0.9),
              child: Text(
                'Pay',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ));
    // set up the buttons

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),

      /// backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
      actions: [
        points,
        pay1,
        point2,
        pay2,
        point3,
        pay3,
      ],
    );

    // show the dialog

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    ref = fb.reference();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      color: Color(0xfffbb448),
      height: height,
      child: Stack(
        children: <Widget>[
          /*  Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),*/
          Wrap(
            children: <Widget>[
              SizedBox(height: 200),
              Align(
                alignment: Alignment.center,
                child: Text(
                  ' ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  ' .99c for a 100 points',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              // SizedBox(height: 50), // give it width
              GradientButton(
                increaseWidthBy: 70,
                increaseHeightBy: 5,
                shapeRadius: BorderRadius.circular(18),
                callback: () {
                  amount = '0.0099';
                  earned_points = "100";
                  // vc.play();
                  // Navigator.pop(context);
                  payViaNewCard(context);
                },
                gradient: Gradients.cosmicFusion,
                shadowColor:
                    Gradients.cosmicFusion.colors.last.withOpacity(0.9),
                child: Text(
                  'Pay',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Text(
                  ' 2.99c for 500 points',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50), // give it width
              GradientButton(
                increaseWidthBy: 70,
                increaseHeightBy: 5,
                shapeRadius: BorderRadius.circular(18),
                callback: () {
                  amount = '0.029900000000000003';
                  earned_points = "500";
                  //Navigator.pop(context);
                  payViaNewCard(context);
                },
                gradient: Gradients.cosmicFusion,
                shadowColor:
                    Gradients.cosmicFusion.colors.last.withOpacity(0.9),
                child: Text(
                  'Pay',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Text(
                  '4.99c for 2000 points',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 50), // give it width
              GradientButton(
                increaseWidthBy: 70,
                increaseHeightBy: 5,
                shapeRadius: BorderRadius.circular(18),
                callback: () {
                  amount = '0.0499';
                  earned_points = "2000";
                  // Navigator.pop(context);
                  payViaNewCard(context);
                },
                gradient: Gradients.cosmicFusion,
                shadowColor:
                    Gradients.cosmicFusion.colors.last.withOpacity(0.9),
                child: Text(
                  'Pay',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

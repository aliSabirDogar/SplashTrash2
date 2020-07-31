import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashtrash/WelcomePage.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/videos/hit_.mp4");
    _controller.play();
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () => showAlertDialog(context));
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 8, 7, 5.0),
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          // showAlertDialog(context);
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                /*    child: VideoPlayer(_controller),*/
                child: VideoPlayer(_controller));
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("hi"),
            ));
  }

  showAlertDialogImage(BuildContext context) {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    Widget cancelButton;
    Widget continueButton;

    Wrap(
      spacing: 100,
      children: <Widget>[
        cancelButton = Image.asset('assets/videos/image_win.png')
        /*  Text("1"),
        SizedBox(width: 50), // give it width
        Text("2"),*/
      ],
    );
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actions: [cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    Widget cancelButton;
    Widget continueButton;

    Wrap(
      spacing: 100,
      children: <Widget>[
        cancelButton = RaisedButton(
          color: Color.fromRGBO(252, 3, 11, 5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(
                Duration(seconds: 2), () => showAlertDialogImage(context));
            _controller.play();
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 220.0,
            height: 50.0,
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Splash',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
        continueButton = RaisedButton(
          color: Color.fromRGBO(252, 3, 11, 5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(
                Duration(seconds: 2), () => showAlertDialogImage(context));
            _controller.play();
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 220.0,
            height: 50.0,
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Trash',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ),
        )
        /*  Text("1"),
        SizedBox(width: 50), // give it width
        Text("2"),*/
      ],
    );
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashtrash/payment/pay.dart';
import 'package:splashtrash/payment/payment-service.dart';
import 'package:splashtrash/viewlecturer.dart';
import 'package:video_player/video_player.dart';

import 'VideoTrimer/editor.dart';

class HomeScreen extends StatefulWidget {
  String sport;
  String id;
  HomeScreen(this.sport);
  // HomeScreen(this.sport, {Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(sport);
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

class _VideoPlayerScreenState extends State<HomeScreen> {
  String sport;
  String id;
  _VideoPlayerScreenState(this.sport);
  String userChoiceVideosUpload;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  VoidCallback listener;
  int win_value, replay = 0;
  String video_name, userChoice;
  static int flag = 0;
  Random random = new Random();
  List<User> allData = new List();
  StorageReference storageReference = FirebaseStorage().ref();
  int TotalDataSize = 0, url = 1, paymentDialogue = 0;
  String amount = '';

  var list_video = ['hit_1.mp4', 'miss_1.mp4', 'miss_2.mp4', 'miss_3.mp4'];
  var list_video_value = [1, 0, 0, 0];
  String fileType = '';
  File file;
  String fileName = '', userChoiceSport, earned_points = " ";
  String operationText = '';
  bool isUploaded = true;
  String result = '';
  VideoViewController vc, vc2;
  var downloadUrl;
  String choice;

  double width, height;

  int _index = 0, payment_flag = 0;

  int get index => _index;

  List<String> source = [
    "https://firebasestorage.googleapis.com/v0/b/mpew2-a3457.appspot.com/o/videos%2Fhit.mp4?alt=media&token=707d72e3-0e15-4766-be33-68925600105c",
    "https://firebasestorage.googleapis.com/v0/b/splashtrash.appspot.com/o/football%2Fhit%2FFootball%20Hits%20(12).mp4?alt=media&token=10b79d45-85ef-4c09-bfb3-d85af61cf749",
    "https://firebasestorage.googleapis.com/v0/b/splashtrash.appspot.com/o/football%2Fhit%2FFootball%20Hits%20(32).mp4?alt=media&token=be193268-53c8-4cc1-a726-4bd6252ae23d"
  ];

  bool viewVisibleReport = false;

  void showWidgetReport() {
    setState(() {
      viewVisibleReport = true;
    });
  }

  void hideWidgetReport() {
    setState(() {
      viewVisibleReport = false;
    });
  }

  bool viewVisiblePlay = false;

  void showWidgetPlay() {
    setState(() {
      viewVisiblePlay = true;
    });
  }

  void hideWidgetPlay() {
    setState(() {
      viewVisiblePlay = false;
    });
  }

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';
  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final String screenUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';
  final String videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  Ads ads;
  final int initOption = 1;
  int _coins = 0;

  @override
  Future<void> initState() {
    StripeService.init();

    GetVideoUrl();

    switch (initOption) {
      case 1:

        /// Assign a listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.clicked) {
            print("The opened ad is clicked on.");
          }
        };

        ads = Ads(
          appId,
          bannerUnitId: bannerUnitId,
          screenUnitId: screenUnitId,
          videoUnitId: videoUnitId,
          keywords: <String>[
            'games',
            'ibm',
            'computers',
            'app games',
            'android',
            'apps'
          ],
          contentUrl: 'http://www.ibm.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: eventListener,
        );

        break;

      case 2:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        ads.setBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: [
            'games',
            'ibm',
            'computers',
            'app games',
            'android',
            'apps'
          ],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.setFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.setVideoAd(
          adUnitId: videoUnitId,
          keywords: [
            'games',
            'ibm',
            'computers',
            'app games',
            'android',
            'apps'
          ],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      case 3:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You just show the Banner, Fullscreen and Video Ads separately.

        ads.showBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: [
            'games',
            'ibm',
            'computers',
            'app games',
            'android',
            'apps'
          ],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.showFullScreenAd(
            adUnitId: screenUnitId,
            keywords: [
              'games',
              'ibm',
              'computers',
              'app games',
              'android',
              'apps'
            ],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.showVideoAd(
          adUnitId: videoUnitId,
          keywords: [
            'games',
            'ibm',
            'computers',
            'app games',
            'android',
            'apps'
          ],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      default:
        ads = Ads(appId, testing: true);
    }

    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/mpew2-a3457.appspot.com/o/videos%2Fhit.mp4?alt=media&token=707d72e3-0e15-4766-be33-68925600105c',
    );

    _controller = VideoPlayerController.asset("assets/videos/win.wav");
    _controller.initialize().then((_) {
      setState(() {
        _initializeVideoPlayerFuture = _controller.initialize();
      });
    });

    int randomNumber = random.nextInt(list_video.length);
    win_value = list_video_value[randomNumber];
    video_name = list_video[randomNumber];

    super.initState();

    ads.eventListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    MobileAdListener eventHandler = (MobileAdEvent event) {
      print("This is an event handler.");
    };

    ads.bannerListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.removeBanner(eventHandler);

    ads.removeEvent(eventHandler);

    ads.removeScreen(eventHandler);

    ads.screenListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case RewardedVideoAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case RewardedVideoAdEvent.opened:
          print("The ad is now open.");
          break;
        case RewardedVideoAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case RewardedVideoAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        case RewardedVideoAdEvent.rewarded:
          print("The ad has sent a reward amount.");
          break;
        case RewardedVideoAdEvent.started:
          print("You've just started playing the Video ad.");
          break;
        case RewardedVideoAdEvent.completed:
          print("You've just finished playing the Video ad.");
          break;
        default:
          print("There's a 'new' RewardedVideoAdEvent?!");
      }
    };

    VoidCallback handlerFunc = () {
      print("The opened ad was clicked on.");
    };

    ads.banner.loadedListener = () {
      print("An ad has loaded successfully in memory.");
    };

    ads.banner.removeLoaded(handlerFunc);

    ads.banner.failedListener = () {
      print("An ad failed to load into memory.");
    };

    ads.banner.removeFailed(handlerFunc);

    ads.banner.clickedListener = () {
      print("The opened ad is clicked on.");
    };

    ads.banner.removeClicked(handlerFunc);

    ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    ads.banner.removeImpression(handlerFunc);

    ads.banner.openedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    ads.banner.removeOpened(handlerFunc);

    ads.banner.leftAppListener = () {
      print("You left the app and gone to the ad's website.");
    };

    ads.banner.removeLeftApp(handlerFunc);

    ads.banner.closedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    ads.banner.removeClosed(handlerFunc);

    ads.screen.loadedListener = () {
      print("An ad has loaded into memory.");
    };

    ads.screen.removeLoaded(handlerFunc);

    ads.screen.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    ads.screen.removeFailed(handlerFunc);

    ads.screen.clickedListener = () {
      print("The opened ad was clicked on.");
    };

    ads.screen.removeClicked(handlerFunc);

    ads.screen.impressionListener = () {
      print("You've clicked on a link in the open ad.");
    };

    ads.screen.removeImpression(handlerFunc);

    ads.screen.openedListener = () {
      print("The ad has opened.");
    };

    ads.screen.removeOpened(handlerFunc);

    ads.screen.leftAppListener = () {
      print("The user has left the app and gone to the opened ad.");
    };

    ads.screen.leftAppListener = handlerFunc;

    ads.screen.closedListener = () {
      print("The ad has been closed. The user returns to the app.");
    };

    ads.screen.removeClosed(handlerFunc);

    ads.video.loadedListener = () {
      print("An ad has loaded in memory.");
    };

    ads.video.removeLoaded(handlerFunc);

    ads.video.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    ads.video.removeFailed(handlerFunc);

    ads.video.clickedListener = () {
      print("An ad has been clicked on.");
    };

    ads.video.removeClicked(handlerFunc);

    ads.video.openedListener = () {
      print("An ad has been opened.");
    };

    ads.video.removeOpened(handlerFunc);

    ads.video.leftAppListener = () {
      print("You've left the app to view the video.");
    };

    ads.video.leftAppListener = handlerFunc;

    ads.video.closedListener = () {
      print("The video has been closed.");
    };

    ads.video.removeClosed(handlerFunc);

    ads.video.rewardedListener = (String rewardType, int rewardAmount) {
      print("The ad was sent a reward amount.");
      setState(() {
        _coins += rewardAmount;
      });
    };

    RewardListener rewardHandler = (String rewardType, int rewardAmount) {
      print("This is the Rewarded Video handler");
    };

    ads.video.removeRewarded(rewardHandler);

    ads.video.startedListener = () {
      print("You've just started playing the Video ad.");
    };

    ads.video.removeStarted(handlerFunc);

    ads.video.completedListener = () {
      print("You've just finished playing the Video ad.");
    };

    ads.video.removeCompleted(handlerFunc);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    ads?.dispose();

    //_bannerAd?.dispose();
    //_nativeAd?.dispose();

    super.dispose();
  }

  Downloddata() async {
    final StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child(sport)
        .child(choice)
        .child(url.toString() + '.mp4');
    try {
      downloadUrl = await storageRef.getDownloadURL();
    } catch (Error) {
      GetVideoUrl();
    }

    if (downloadUrl != null) {
      setState(() {
        vc.setVideoSource(
          downloadUrl,
          sourceType: VideoSourceType.network,
        );
      });
    } else {
      GetVideoUrl();
    }
    /*.then((value) {

    });*/

    final FirebaseApp app = await FirebaseApp.configure(
      name: 'SplashTrash',
      options: FirebaseOptions(
        googleAppID: '1:569442823893:android:0ad2f96dcc836cb2ca7c5c',
        gcmSenderID: '569442823893',
        apiKey: 'AIzaSyDUsOMPG3sEnTPwfQPUyyjTT-DOk4ZKKXw',
        projectID: 'splashtrash',
      ),
    );
    final FirebaseStorage storage = FirebaseStorage(
        app: app, storageBucket: 'gs://splashtrash.appspot.com');
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    height = height - 155;

    ads.showBannerAd(state: this, anchorOffset: null);

    return Scaffold(
      backgroundColor: Color(0xfffbb448),
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => viewlecturer()));
            },
            textColor: Color(0xfffbb448),
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: const Text(
                'Leader Board',
                style: TextStyle(fontSize: 15, color: Color(0xfffbb448)),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(0xfffbb448),
            ),
            onPressed: () async {
              showWidgetPlay();
              vc.pause();
              vc.stop();

              fileType = 'video';
              SchedulerBinding.instance.addPostFrameCallback((_) {
                // add your code here.
                // vc.play();
                // Navigator.pop(context);
                setState(() {
                  showAlertDialogSettings(context);
                });
              });
            },
          ),
        ],
        backgroundColor: Colors.white,
        title: Text(
          'Splash Trash',
          style: TextStyle(fontSize: 15, color: Color(0xfffbb448)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: _buildVideoPlayerWidget(),
    );
  }

  DeleteVideo() {}

  Widget _buildVideoPlayerWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              '  initializing.....',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(width: 20),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: viewVisibleReport,
                child: Container(
                  child: GradientButton(
                    shapeRadius: BorderRadius.circular(18),
                    callback: () async {
                      StorageReference storageRef;

                      vc.pause();
                      vc.stop();

                      storageRef = FirebaseStorage.instance
                          .ref()
                          .child(sport)
                          .child(choice)
                          .child(url.toString() + '.mp4');
                      storageRef.delete();

                      GetVideoUrl();
                    },
                    gradient: Gradients.cosmicFusion,
                    shadowColor:
                        Gradients.cosmicFusion.colors.last.withOpacity(0.9),
                    child: Text(
                      'Report',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                )),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: viewVisiblePlay,
                child: Container(
                  child: GradientButton(
                    shapeRadius: BorderRadius.circular(18),
                    callback: () {
                      replay = 0;

                      GetVideoUrl();
                    },
                    gradient: Gradients.cosmicFusion,
                    shadowColor:
                        Gradients.cosmicFusion.colors.last.withOpacity(0.9),
                    child: Text(
                      'Play',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ))
          ],
        ),
        Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: NativeVideoView(
            // autoHide: true,
            keepAspectRatio: true,
            onCreated: (controller) {
              vc = controller;
            },
            onProgress: (progress, duration) {
              var prg = progress;

              if (replay == 1) {
                if (prg >= duration / 2.5) {
                  showWidgetPlay();
                }
              }
              if (progress > 10 && progress < 20) {
                showWidgetReport();
              }

              if (flag == 0) {
                if (replay == 0) {
                  if (prg >= duration / 2.5) {
                    flag = 1;
                    vc.pause();
                    hideWidgetReport();

                    showAlertDialog(context);
                  }

                  var durat = duration;
                }
              }
            },
            onPrepared: (controller, info) {
              vc.play();
              showWidgetReport();

              //Loader.hide();
              //showWidget();

              // Future.delayed(Duration(seconds: 4), () => Loader.hide());
            },
            onError: (controller, what, extra, message) {
              print('Player Error ($what | $extra | $message)');
            },
            onCompletion: (controller) {
              //showAlertDialogPayment(context);
              print('Video completed');

              flag = 0;
              _index = _index + 1;

              if (userChoice == "hit") {
                if (choice == "hit") {
                  if (replay == 0) showAlertDialogWinImage(context);
                } else {
                  if (replay == 0) showAlertDialogLostImage(context);
                }
              } else if (userChoice == "miss") {
                if (choice == "miss") {
                  if (replay == 0) showAlertDialogWinImage(context);
                } else {
                  if (replay == 0) showAlertDialogLostImage(context);
                }
              }
            },
          ),
        ),
      ],
    );
  }

  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (video.path != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Editor(picked: video)),
      );
    }
  }

  UpdateVideoFirebaseRealtime(int size) {
    final fb = FirebaseDatabase.instance;

    var ref = null;

    ref = fb.reference();

    for (int i = 0; i < size; i++) {
      ref
          .child("Videos")
          .child(userChoiceSport)
          .child(userChoiceVideosUpload)
          .child(i.toString())
          .set(userChoiceVideosUpload);
      // ref.child("Videos").child(sport).child("miss").set(i.toString());
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
    }
    if (fileType == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
    }
    if (fileType == 'video') {
      UpdateVideoFirebaseRealtime(TotalDataSize);
      storageReference = FirebaseStorage.instance.ref().child(
          sport + "/" + userChoiceVideosUpload + "/" + filename + ".mp4");
    }
    if (fileType == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    }
    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  NextRound(BuildContext context) {}

  showAlertDialogLostImage(BuildContext context) {
    //  if (_controller.value.isPlaying)
    {
      _controller.pause();

      _controller = VideoPlayerController.asset("assets/videos/lost_soud.wav");
      _controller.play();

      _initializeVideoPlayerFuture = _controller.initialize();
    }

    Widget cancelButton;
    Widget continueButton;

    Wrap(
      spacing: 100,
      children: <Widget>[
        cancelButton = Image.asset(
          'assets/videos/cross.png',
          fit: BoxFit.contain,
        ),

        SizedBox(width: 100), // give it width
      ],
    );
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),

      /// backgroundColor: Color.fromRGBO(255, 0, 0, 0.5),
      actions: [
        cancelButton,
        SizedBox(
          height: 50,
        ),
        //  continueButton
      ],
    );

    // show the dialog

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);

            vc.stop();
            GetVideoUrl();
          });
          return alert;
        });
  }

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
        myInt = myInt + 100;

        final fb = FirebaseDatabase.instance;

        var ref = null;

        ref = fb.reference();

        ref.child(token).child("score").set(myInt);
      });
    });
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
          style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
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
      payment_flag = 0;
      GetVideoUrl();
    } else {
      Navigator.of(context).pop(true);
      payment_flag = 0;
      GetVideoUrl();
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  showAlertDialogSettings(BuildContext context) {
    //payment_flag = 1;
    vc.pause();
    Widget videos, payment;

    Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Wrap(
          children: <Widget>[
            videos = payment = GradientButton(
              increaseWidthBy: 70,
              increaseHeightBy: 5,
              shapeRadius: BorderRadius.circular(18),
              callback: () {
                // vc.play();
                // Navigator.pop(context);
                showAlertDialogSports(context);
              },
              gradient: Gradients.cosmicFusion,
              shadowColor: Gradients.cosmicFusion.colors.last.withOpacity(0.9),
              child: Text(
                'Upload',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),

            SizedBox(height: 50), // give it width
            payment = GradientButton(
              increaseWidthBy: 70,
              increaseHeightBy: 5,
              shapeRadius: BorderRadius.circular(18),
              callback: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => pay()));
                  // Add Your Code here.
                });
                // add your code here.
                // vc.play();
                // Navigator.pop(context);
                /*       setState(() {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => pay()));
                });*/
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
        videos,
        payment,
      ],
    );

    // show the dialog

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  showAlertDialogPayment(BuildContext context) {
    payment_flag = 1;
    vc.pause();
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
                style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
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
                style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
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
                style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
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

  showAlertDialogWinImage(BuildContext context) {
    {
      _controller.pause();

      _controller = VideoPlayerController.asset("assets/videos/win.wav");
      _controller.play();

      _initializeVideoPlayerFuture = _controller.initialize();
    }

    Widget cancelButton;
    Widget continueButton;
    Widget points;

    Wrap(
      spacing: 100,
      children: <Widget>[
        points = Text(
          'Congrats You Earned 50 Points',
          style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        cancelButton = Image.asset(
          'assets/videos/win_game.png',
        ),

        SizedBox(width: 50), // give it width
        continueButton = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            setState(() {
              vc.play();
            });
            Navigator.pop(context);
            replay = 1;
          },
          gradient: Gradients.cosmicFusion,
          shadowColor: Gradients.cosmicFusion.colors.last.withOpacity(0.9),
          child: Text(
            'Replay',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
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

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            UpdateScore();
            Navigator.of(context).pop(true);
            vc.stop();

            GetVideoUrl();
          });
          return alert;
        });
  }

  GetVideoUrl() {
    hideWidgetReport();
    hideWidgetPlay();

    int randomNumber = random.nextInt(2);

    if (randomNumber == 1) {
      choice = "hit";
    } else if (randomNumber == 0) {
      choice = "miss";
    }

    int jmlPria;
    FirebaseDatabase.instance
        .reference()
        .child("Videos")
        .child(sport)
        .child(choice)
        .once()
        .then((onValue) {
      List<String> streetsList = new List<String>.from(onValue.value);
      //Map data = onValue.value;
      TotalDataSize = streetsList.length;
      if (TotalDataSize != 0) {
        url = random.nextInt(TotalDataSize);
        if (url == 0) {
          url = random.nextInt(TotalDataSize);
        }
        if (url != 0) {
          Downloddata();
        }
      }
    });
  }

  void ReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Report"),
          content: new Text("You have reported this video!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("ok"),
              onPressed: () {
                //  Navigator.popUntil(context, ModalRoute.withName("/HomeScreen"));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  GetTotalCount() {
    FirebaseDatabase.instance
        .reference()
        .child("Videos")
        .child(userChoiceSport)
        .child(userChoiceVideosUpload)
        .once()
        .then((onValue) {
      List<String> streetsList = new List<String>.from(onValue.value);
      //Map data = onValue.value;
      TotalDataSize = streetsList.length;
      //  TotalDataSize = TotalDataSize + 1;
      _uploadFile(file, TotalDataSize.toString());
    });
  }

  showAlertDialogSports(BuildContext context) {
    Widget football, soccer, other;
    Widget baseball;
    Widget basketball;
    Widget text, note;

    Wrap(
      spacing: 100,
      children: <Widget>[
        text = Text(
          'Please choose sport category?',
          style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        note = Text(
          'Note: Video should not longer than 6 sec!',
          style: TextStyle(fontSize: 15, color: Color(0xfffbb448)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        football = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);
            userChoiceSport = "football";
            showAlertDialogUplaodVideos(context);
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(1),
          child: Text(
            'football',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        baseball = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);
            userChoiceSport = "baseball";
            showAlertDialogUplaodVideos(context);
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(1),
          child: Text(
            'baseball',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        basketball = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);
            userChoiceSport = "basketball";
            showAlertDialogUplaodVideos(context);
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(0.9),
          child: Text(
            'basketball',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        soccer = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);
            userChoiceSport = "soccer";
            showAlertDialogUplaodVideos(context);
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(0.9),
          child: Text(
            'soccer',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        other = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);
            userChoiceSport = "other";
            showAlertDialogUplaodVideos(context);
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(0.9),
          child: Text(
            'other',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),
      actions: [
        text,
        SizedBox(
          height: 50,
        ),
        note,
        SizedBox(
          height: 50,
        ),
        basketball,
        SizedBox(
          height: 50,
        ),
        football,
        SizedBox(
          height: 50,
        ),
        baseball,
        SizedBox(
          height: 50,
        ),
        soccer,
        SizedBox(
          height: 50,
        ),
        other
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

  showAlertDialogUplaodVideos(BuildContext context) {
    Widget cancelButton;
    Widget continueButton;
    Widget text;

    Wrap(
      spacing: 100,
      children: <Widget>[
        text = Text(
          'Please  specify is it HIT or Miss ?',
          style: TextStyle(fontSize: 20, color: Color(0xfffbb448)),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        cancelButton = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () async {
            Navigator.pop(context);
            userChoiceVideosUpload = "hit";

            // final int counter = (prefs.getInt('counter') ?? 0) + 1;
            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {
              prefs.setString('sport', userChoiceSport);
              prefs.setString('selection', userChoiceVideosUpload);
            });
            // UpdateVideoFirebaseRealtime(1);
            _pickVideo();
            // GetTotalCount();
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(1),
          child: Text(
            'Hit',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        continueButton = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () async {
            Navigator.pop(context);
            userChoiceVideosUpload = "miss";
            SharedPreferences prefs = await SharedPreferences.getInstance();

            setState(() {
              prefs.setString('sport', userChoiceSport);
              prefs.setString('selection', userChoiceVideosUpload);
            });
            //UpdateVideoFirebaseRealtime(1);
            _pickVideo();
            // GetTotalCount();
          },
          gradient: Gradients.blush,
          shadowColor: Gradients.blush.colors.last.withOpacity(0.9),
          child: Text(
            'Miss',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),
      actions: [
        text,
        SizedBox(
          height: 50,
        ),
        cancelButton,
        SizedBox(
          height: 50,
        ),
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

  showAlertDialog(BuildContext context) {
    Widget cancelButton;
    Widget continueButton;

    Wrap(
      spacing: 100,
      children: <Widget>[
        cancelButton = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            userChoice = "hit";

            Navigator.pop(context);
            vc.play();
          },
          gradient: Gradients.aliHussien,
          shadowColor: Gradients.aliHussien.colors.last.withOpacity(1),
          child: Text(
            'Splash',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        continueButton = GradientButton(
          increaseWidthBy: 100,
          increaseHeightBy: 10,
          shapeRadius: BorderRadius.circular(18),
          callback: () {
            Navigator.pop(context);

            userChoice = "miss";

            vc.play();
          },
          gradient: Gradients.ali,
          shadowColor: Gradients.ali.colors.last.withOpacity(0.9),
          child: Text(
            'Trash',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black12.withOpacity(0),
      actions: [
        cancelButton,
        SizedBox(
          height: 50,
        ),
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

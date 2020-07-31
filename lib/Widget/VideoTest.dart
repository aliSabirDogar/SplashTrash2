import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';

class VideoTest extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VideoTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildVideoPlayerWidget(),
    );
  }

  Widget _buildVideoPlayerWidget() {
    return Container(
      alignment: Alignment.center,
      child: NativeVideoView(
        keepAspectRatio: true,
        // showMediaController: true,
        onCreated: (controller) {
          controller.setVideoSource(
            'https://firebasestorage.googleapis.com/v0/b/splashtrash.appspot.com/o/football%2Fhit%2FFootball%20Hits%20(1).mp4?alt=media&token=3c7d70c8-6213-421b-a908-b249a2d83a30',
            sourceType: VideoSourceType.network,
          );
        },
        onPrepared: (controller, info) {
          controller.play();
        },
        onError: (controller, what, extra, message) {
          print('Player Error ($what | $extra | $message)');
        },
        onCompletion: (controller) {
          print('Video completed');
        },
      ),
    );
  }
}

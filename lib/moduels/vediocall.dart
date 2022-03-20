import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'agora_manager.dart';

// ignore: must_be_immutable
class VideoCall extends StatefulWidget {
  VideoCall(this.channelName, this.channelToken);

  String channelName;
  String channelToken;

  @override
  _VideoCAllState createState() => _VideoCAllState();
}

class _VideoCAllState extends State<VideoCall> {
  int _remoteUid = 0;
 late RtcEngine _engine;

  @override
  void initState() {
    print(widget.channelToken);
    print(widget.channelToken);
    print("widget.channelToken");
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
    _remoteUid = 0;
    _engine.disableAudio();
    _engine.disableVideo();
  }

  Future<void> initAgora() async {
    setState(() {});
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    //create the engine
    _engine = await RtcEngine.create(AgoraManager.appId);
    await _engine.enableVideo();
    await _engine.enableAudio();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('$uid successfully joined channel: $channel ');
          print('uid successfully joined channel: channel ');
          print('$uid successfully joined channel: $channel ');
          setState(() {});
        },
        userJoined: (int uid, int elapsed) {
          print('remote user $uid joined channel');
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print('remote user $uid left channel');
          setState(() {
            _remoteUid = 0;
            _engine.leaveChannel();
            _engine.disableAudio();
            _engine.disableVideo();
            if (reason == UserOfflineReason.Quit ||
                reason == UserOfflineReason.Dropped)
              Navigator.of(context).pop(true);
          });
        },
      ),
    );
    await _engine.joinChannel(widget.channelToken, widget.channelName, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 150,
                height: 150,
                child: Center(
                  child: _renderLocalVideo(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          heroTag: "v1",
          onPressed: () {
            setState(() {
              _engine.leaveChannel();
              _remoteUid = 0;
              _engine.disableAudio();
              _engine.disableVideo();
              Navigator.of(context).pop(true);
            });
          },
          child: Icon(Icons.call_outlined),
          backgroundColor: Color(0xFFFF6969),
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    // ignore: unnecessary_null_comparison
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(
        channelId: AgoraManager.channelName,
        renderMode: VideoRenderMode.FILL,
        uid: _remoteUid,
      );
    } else {
      return Text(
        'Calling...',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _renderLocalVideo() {
    return RtcLocalView.SurfaceView();
  }
}
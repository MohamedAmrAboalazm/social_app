import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:social_app/moduels/agora_manager.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class VedioCallScreen extends StatefulWidget {

  VedioCallScreen(this.channelName, this.channelToken);

  String? channelName;
  String? channelToken;

  @override
  State<VedioCallScreen> createState() => _VedioCallScreenState();
}

class _VedioCallScreenState extends State<VedioCallScreen> {
  @override
  void initState() {
    super.initState();
   initAgora(context, widget.channelName, widget.channelToken);
  }
  late int remoteUId=0;
  late RtcEngine engine;
  Future<void> initAgora(context,channelName,channelToken) async {
    await [Permission.microphone, Permission.camera].request();
    engine = await RtcEngine.create(AgoraManager.appId);
    engine.enableVideo();
    engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('local user $uid joined successfully');
        },
        userJoined: (int uid, int elapsed) {
// player.stop();
          print('remote user $uid joined successfully');
          remoteUId=uid;
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print('remote user $uid left call');
          remoteUId = 0;
          Navigator.of(context).pop(true);
        },
      ),
    );
    await engine.joinChannel(
        channelToken, channelName, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: _renderRemoteVideo(context),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150.0),
                    child: Container(
                        height: 150, width: 150, child: _renderLocalPreview()),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                          IconButton(
                            onPressed: (){
                              SocialCubit.get(context).engine.leaveChannel();
                              Navigator.of(context).pop(true);
                            },
                            icon:Icon(Icons.call_end, size: 44,
                              color: Colors.redAccent,) ,

                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );


      },
    );
  }

  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

//remote User View
  Widget _renderRemoteVideo(context) {
    if ( SocialCubit.get(context).remoteUId!= 0) {
      return  RtcRemoteView.SurfaceView(
        channelId: AgoraManager.channelName,
        uid: SocialCubit.get(context).remoteUId,
      );
    } else {
      return Text(
      'Calling …',
      style: Theme.of(context).textTheme.headline6,
    textAlign: TextAlign.center,
    );
    }
    }
}

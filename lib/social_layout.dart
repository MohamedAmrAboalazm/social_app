import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/moduels/chat_detaials_screen.dart';
import 'package:social_app/moduels/edit_profile_screen.dart';
import 'package:social_app/moduels/newpost_screen.dart';
import 'package:social_app/moduels/vedio_call_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'models/Social_user_model.dart';
import 'moduels/vediocall.dart';

//Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
//  print("on background message");
//  print(event.data.toString());
//  SocialUserModel model= SocialUserModel.fromJson(json.decode(event.data["screen"]));
//  print(model.name);
//  print(event.data["screen"].toString());
//  if(event.data["click_action"]=="chat")
//    navigateTo(context,ChatDetailsScreen(model));
//  if(event.data["click_action"]=="vedio")
//    navigateTo(context,VideoCall(event.data["channelName"],event.data["channelToken"]));
//  showToast(message: "on background message", state: ToastStates.SUCCES);
//}
class SocialLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("on message opened app");
      //print(event.data.toString());
     SocialUserModel model= SocialUserModel.fromJson(json.decode(event.data["screen"]));
     print(model.name);
           print(event.data["screen"].toString());
              if(event.data["click_action"]=="chat")
               navigateTo(context,ChatDetailsScreen(model));
      if(event.data["click_action"]=="vedio")
        navigateTo(context,VideoCall(event.data["channelName"],event.data["channelToken"]));
      showToast(message: "onMessageOpenedApp", state: ToastStates.SUCCES);
    });
    FirebaseMessaging.onMessage.listen((event) {
      print("On Message");
      print(event.data.toString());
      showToast(message: "On Message", state: ToastStates.SUCCES);
    });
    return BlocConsumer<SocialCubit,SocialState>(
        listener: (context, state) {
          if(state is SocialNewPostState)
            {
              navigateTo(context, NewPostScreen());
            }
        },
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.Titles[cubit.CurrentIndex]),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Notification)),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search)),
            ],
          ),
          body: cubit.bottomScreens[cubit.CurrentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              cubit.changeIndex(value);
            },
            currentIndex: cubit.CurrentIndex,
            items: cubit.BottomItem,

          ),
        );
      }
    );
  }
}

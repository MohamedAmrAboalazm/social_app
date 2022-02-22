import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/moduels/chats_screen.dart';
import 'package:social_app/moduels/feeds_screen.dart';
import 'package:social_app/moduels/settings_screen.dart';
import 'package:social_app/moduels/users_screen.dart';
import 'package:social_app/shared/styles/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';




class SocialCubit extends Cubit<SocialState>{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context)=>BlocProvider.of(context);

     SocialUserModel? model;
     void getUserData()
     {
       emit(SocialGetUserLoadingState());
       FirebaseFirestore.instance
           .collection("users")
           .doc(uId)
           .get()
           .then((value) {
             print(value.data());
             model=SocialUserModel.fromJson(value.data());
             emit(SocialGetUserSuccessState());
       })
           .catchError((erorr){
         print(erorr.toString());
         emit(SocialGetUserErorrState(erorr.toString()));
       });
     }
  int CurrentIndex = 0;
  List<Widget> bottomScreens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),

  ];
  List<String> Titles = [
    "Home",
    "Chats",
    "Users",
    "Settings",


  ];
  List<BottomNavigationBarItem> BottomItem = [
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Chat),
      label: "Chats",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Location),
      label: "Users",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconBroken.Setting),
      label: "Settings",
    ),
  ];
  void changeIndex(int index) {

      CurrentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }



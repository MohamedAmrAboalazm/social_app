import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/moduels/chats_screen.dart';
import 'package:social_app/moduels/feeds_screen.dart';
import 'package:social_app/moduels/newpost_screen.dart';
import 'package:social_app/moduels/settings_screen.dart';
import 'package:social_app/moduels/users_screen.dart';
import 'package:social_app/shared/styles/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;




class SocialCubit extends Cubit<SocialState>{
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context)=>BlocProvider.of(context);

     SocialUserModel? userModel;
     void getUserData()
     {
       emit(SocialGetUserLoadingState());
       FirebaseFirestore.instance
           .collection("users")
           .doc(uId)
           .get()
           .then((value) {
             print(value.data());
             userModel=SocialUserModel.fromJson(value.data());
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
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),

  ];
  List<String> Titles = [
    "Home",
    "Chats",
    "Post",
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
      icon: Icon(IconBroken.Upload),
      label: "Post",
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
     if(index==2)
       {
         emit(SocialNewPostState());
       }
     else {
       CurrentIndex = index;
       emit(SocialChangeBottomNavState());
     }
    }
   File? profileImage;
  var picker =ImagePicker();
  Future<void> getProfileImage()async
  {
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    {
      profileImage=File(pickedFile.path);
      print(profileImage);
      emit(SocialProfileImagePickedSucessState());
    }
    else
    {
      emit(SocialProfileImagePickedErorrState());
      print("No image selected");
    }
  }
  File? coverImage;
  Future<void> getCoverImage()async
  {
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    {
      coverImage=File(pickedFile.path);
      print(coverImage);
      emit(SocialCoverImagePickedSucessState());
    }
    else
    {
      emit(SocialCoverImagePickedErorrState());
      print("No image selected");
    }
  }

 void uploadProfileImage({
  required String name,
  required String phone,
  required String bio,
  String? profile,
 })
 {
   emit(SocialLoadingUpdateUserDateState());
   firebase_storage
       .FirebaseStorage
       .instance
       .ref()
       .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
       .putFile(profileImage!)
       .then((value) {

        value.ref.getDownloadURL().then((value) {
          print(value);
          //emit(SocialUploadProfileImageSucessState());
          updateUser(name: name, phone: phone, bio: bio,profile: value);
        })
            .catchError((e){
          emit(SocialUploadProfileImageErorrState());
        });
   }).catchError((e){
     print("________"+e.toString());
     emit(SocialUploadProfileImageErorrState());
   });

 }

  void uploadcoverImage({
    required String name,
    required String phone,
    required String bio,
    String? cover,
  })
  {
    emit(SocialLoadingUpdateUserDateState());
    firebase_storage
        .FirebaseStorage
        .instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {

      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, phone: phone, bio: bio,cover:value);
      //  emit(SocialUploadProfileImageSucessState());
      })
          .catchError((e){
        emit(SocialUploadProfileImageErorrState());
      });
    }).catchError((e){
      print("________"+e.toString());
      emit(SocialUploadProfileImageErorrState());
    });

  }


  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profile,
    String? cover,
  })
       {
  emit(SocialLoadingUpdateUserDateState());
SocialUserModel model=SocialUserModel(
phone: phone,
name: name,
bio:bio,
isEmailVerified: false,
email: userModel!.email,
uId: userModel!.uId,
image: profile??userModel!.image,
cover: cover??userModel!.cover,
);
FirebaseFirestore.instance
    .collection("users")
    .doc(uId)
    .update(model.toMap())
    .then((value){

      getUserData();
    })
    .catchError((erorr){
    emit(SocialUpdateUserDateErorrState());
});
}

  File? postImage;
  Future<void> getPostImage()async
  {
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    {
      postImage=File(pickedFile.path);
      print(postImage);
      emit(SocialPostImagePickedSucessState());
    }
    else
    {
      emit(SocialPostImagePickedErorrState());
      print("No image selected");
    }
  }
  void uploadPostImage({
    required String text,
    required String dateTime,

  })
  {
    emit(SocialCreatePostLoadingState());
    firebase_storage
        .FirebaseStorage
        .instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {

      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(text: text, dateTime: dateTime,postImage: value);

      })
          .catchError((e){
        emit(SocialCreatePostErorrState());
      });
    }).catchError((e){
      print("________"+e.toString());
      emit(SocialCreatePostErorrState());
    });



  }


  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  })
  {
    emit(SocialCreatePostLoadingState());
    PostModel model=PostModel(
      name: userModel!.name,
      image:userModel!.image ,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??"",

    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(model.toMap())
        .then((value){
      emit(SocialCreatePostSucessState());
    })
        .catchError((erorr){
      emit(SocialCreatePostErorrState());
    });
  }
void removePostImage()
{
  postImage=null;
  emit(SocialRemovePostImageState());
}
  }



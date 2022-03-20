import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/token_model.dart';
import 'package:social_app/moduels/chats_screen.dart';
import 'package:social_app/moduels/feeds_screen.dart';
import 'package:social_app/moduels/newpost_screen.dart';
import 'package:social_app/moduels/settings_screen.dart';
import 'package:social_app/moduels/users_screen.dart';
import 'package:social_app/shared/styles/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

import '../moduels/agora_manager.dart';

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
             getToken();
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
    if(index==1) {
      getUsers();
    }
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
    final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 25,);
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
    final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality:25);
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
    final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);
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
      image:userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??"",

    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(model.toMap())
        .then((value){
          getPosts();
      emit(SocialCreatePostSucessState());
    })
        .catchError((erorr){
      emit(SocialCreatePostErorrState());
    });
  }
  List<PostModel> posts=[];
  List<String> postId=[];
  List<int> Likes=[];
  List<int> Comments=[];
  void getPosts(){

    emit(SocialGetPostsLoadingState());
   FirebaseFirestore
       .instance
       .collection("posts")
        .orderBy("dateTime",descending: true)
         .get()
       .then((value) {
         value.docs.forEach((element) {
           element
           .reference
           .collection("likes")
           .get()
           .then((value){
             Likes.add(value.docs.length);
             postId.add(element.id);
             posts.add(PostModel.fromJson(element.data()));
           })
           .catchError((erorr){

           });
         });
         emit(SocialGetPostsSuccessState());
   })
       .catchError((erorr){
         emit(SocialGetPostsErorrState(erorr));
   });
  }
void removePostImage()
{
  postImage=null;
  emit(SocialRemovePostImageState());
}

  void likePost(String postId)
  {
    FirebaseFirestore
        .instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(userModel!.uId.toString())
        .set({"like":true,})
        .then((value) {

          emit(SocialLikePostSuccessState());
    })
        .catchError((erorr){
      emit(SocialLikePostErorrState(erorr));
    });
  }

  void CommentPost(String postId)
  {
    FirebaseFirestore
        .instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(userModel!.uId.toString())
        .set({"comment":"comment1",})
        .then((value) {

        emit(SocialCommentPostSuccessState());
    })
        .catchError((erorr){
      emit(SocialCommentPostErorrState(erorr));
    });
  }
  List<SocialUserModel> users=[];

   void getUsers()
   {

     emit(SocialGetAllUsersLoadingState());
     if(users.length==0)
     FirebaseFirestore
         .instance
         .collection("users")
         .get()
         .then((value) {
       value.docs.forEach((element) {
            if(element.data()["uId"]!=userModel!.uId)
           users.add(SocialUserModel.fromJson(element.data()));
       });
       emit(SocialGetAllUsersSuccessState());
     })
         .catchError((erorr){
       emit(SocialGetAllUsersErorrState(erorr));
     });
   }

   void sendMessage({
      String? text,
      String? receiverId,
      String? datetime,
     String? chatImage,


   })
   {
     MessageModel model=MessageModel(text: text,receiveruId: receiverId,senderuId: userModel!.uId,dateTime: datetime,chatImage:chatImage);
     FirebaseFirestore
         .instance
         .collection("users")
         .doc(userModel!.uId)
         .collection("chat")
         .doc(receiverId)
         .collection("messages")
         .add(model.toMap())
         .then((value){
           emit(SocialSendMessageSucessState());
     })
         .catchError((erorr){
       emit(SocialSendMessageErorrState());
     });
     FirebaseFirestore
         .instance
         .collection("users")
         .doc(receiverId)
         .collection("chat")
         .doc(userModel!.uId)
         .collection("messages")
         .add(model.toMap())
         .then((value){
       emit(SocialSendMessageSucessState());
     })
         .catchError((erorr){
       emit(SocialSendMessageErorrState());
     });
   }
   List<MessageModel> messages=[];
   void getMessages({required String? receiverId})
   {
     FirebaseFirestore.instance
         .collection("users")
         .doc(userModel!.uId)
         .collection("chat")
         .doc(receiverId)
         .collection("messages")
         .orderBy("dateTime",descending: true)
         .snapshots()
         .listen((event) {
           messages=[];
           event.docs.forEach((element) {
             messages.add(MessageModel.fromJson(element.data()));

           });
           emit(SocialGetMessagesSucessState());
     });

   }

  File? chatImage;
  Future<void> getChatImage()async
  {
    final pickedFile=await picker.pickImage(source: ImageSource.camera,imageQuality: 25,maxHeight: 400);
    if(pickedFile!=null)
    {
      chatImage=File(pickedFile.path);
      print(chatImage);
      emit(SocialChatImageSucessState());
    }
    else
    {
      emit(SocialChatImageErorrState());
      print("No image selected");
    }
  }
  void uploadChatImage({
     String? dateTime,
    String? receiverId,
  })
  {
    emit(SocialUploadChatImageLoadingState());
    firebase_storage
        .FirebaseStorage
        .instance
        .ref()
        .child("chatImage/${Uri.file(chatImage!.path).pathSegments.last}")
        .putFile(chatImage!)
        .then((value) {

      value.ref.getDownloadURL().then((value) {
        print(value);
        emit(SocialUploadChatImageSucessState());
       sendMessage(chatImage:value,datetime:dateTime,receiverId:receiverId);
      })
          .catchError((e){
        emit(SocialUploadProfileImageErorrState());
      });
    }).catchError((e){
      print("________"+e.toString());
      emit(SocialUploadProfileImageErorrState());
    });

  }

//  void notifyMessage()
//  {
//
//     DioHelper.postData(url: "fcm/send",
//         data:
//           {
//             "to": "eIF7mhPCTmKMwbmj768UyH:APA91bFJRPLG0blCtK0aBS3v5ftfvqlOyr5I_XVYVJNsM5QblbfIzipUsreoRI6l9P6LMrJ9zdk_WHjtLGDwhPYbRi3AngPowbzQetvz6mBlDRzoUlQLQNkWbQQo8KNHBynjaQWMN2cJ",
//             "notification": {
//               "title": "Mohamed Amr",
//               "body": "message ya 3m al7g",
//
//             },
//             "android": {
//               "priority": "High"
//             },
//             "data": {
//               "type": "order",
//               "id": "87",
//               "click_action": "FLUTTER_NOTIFICATION_CLICK"
//             }
//           }
//
//     ).then((value) {
//
//       emit(SocialNotifyMessageSucessState());
//     }).catchError((e){
//          print(e.toString());
//       emit(SocialNotifyMessageErorrState());
//     });
//
//  }

  void saveToken(String? token,String? uId) async {
    TokenModel tokenModel=TokenModel(token: token,uId: uId);
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(userModel!.uId)
        .set(tokenModel.toMap()).then((value) {
   emit(SocialSaveTokenSucessState());
    })
      .catchError((e){
   emit(SocialSaveTokenErorrState());
    });

  }
  String? Token;

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token)
        {
          Token=token;
          print("22"+Token.toString());
          saveToken(Token,userModel!.uId);

        }
    );
  }
  void sendPushMessage({String? token, String? body, String? title, SocialUserModel? model,String? click,String? channelName,String? channelToken}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA02h14ew:APA91bG7rvrJpbxTQfNLe0a9j1nVoJ8ULiMpDRriwELzBmM6Ig36wMh1y5muIl5Nmu_0pJVKcgY9GyrJ-DnUtyTQMeGTs_pCi1FloZ2fev7sgzculyBKmX48L7w1lDVcaZXxigtnlnNg',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body':body,
              'title': title
            },
            'priority': 'high',
            'data': <String, String>{
              'click_action': '$click',
              'id': '1',
              'status': 'done',
              'channelName':channelName!,
              'channelToken':channelToken!,
              'screen':json.encode(model!.toMap()) ,
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }


  List<TokenModel> tokens=[];

  void getTokens()
  {
    tokens=[];
     emit(SocialGetTokenLoadingState());
      FirebaseFirestore
          .instance
          .collection("UserTokens")
          .get()
          .then((value) {
        emit(SocialGetTokenSucessState());
        value.docs.forEach((element) {
            tokens.add(TokenModel.fromJson(element.data()));

        });
        print("11111111"+ tokens[0].token.toString());

      })
          .catchError((erorr){
        emit(SocialGetTokenErorrState());
      });
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

}


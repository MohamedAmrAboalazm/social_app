import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../cubit/cubit.dart';
import '../shared/styles/colors.dart';

class ChatImageScreen extends StatelessWidget {
  SocialUserModel model;
  ChatImageScreen(this.model);

  @override
  Widget build(BuildContext context) {
    var textController=TextEditingController();
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context, state) {
        if(state is SocialUploadChatImageSucessState)
          {
            Navigator.pop(context);
            SocialCubit.get(context).chatImage=null;
          }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              if(state is SocialUploadChatImageLoadingState)
                LinearProgressIndicator(),
              Expanded(child: Image(image: SocialCubit.get(context).chatImage==null?
              NetworkImage("https://media.istockphoto.com/vectors/male-profile-flat-blue-simple-icon-with-long-shadow-vector-id522855255?k=20&m=522855255&s=612x612&w=0&h=fLLvwEbgOmSzk1_jQ0MgDATEVcVOh_kqEe0rqi7aM5A="):
              FileImage(File(SocialCubit.get(context).chatImage!.path)) as ImageProvider,) ),
              Container(
                decoration:BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width:1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          onFieldSubmitted: (s){

                          },
                          controller: textController,
                          decoration: InputDecoration(
                              border:InputBorder.none,
                              hintText: "type your message here ...."

                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: MaterialButton(onPressed: (){
                        SocialCubit.get(context).getChatImage();
                      },
                        minWidth: 1,
                        child: Icon(IconBroken.Camera,color: Colors.blue,size: 16,),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: defaultColor,
                      child: MaterialButton(onPressed: (){

                        SocialCubit.get(context).uploadChatImage(receiverId: model.uId,dateTime: DateTime.now().toString());


                      },
                        minWidth: 1,
                        child: Icon(IconBroken.Send,color: Colors.white,size: 16,),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
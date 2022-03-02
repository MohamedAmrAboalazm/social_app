import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var textController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var postImage=SocialCubit.get(context).postImage;
           return   Scaffold(
             appBar:defaultAppBar(
          context: context,
          title: "Create Post",
          actions:[
            TextButton(onPressed: (){
              var now=DateTime.now();
              if(SocialCubit.get(context).postImage==null)
                {
                  SocialCubit.get(context).createPost(text: textController.text, dateTime: now.toString());
                }
              else
                {
                  SocialCubit.get(context).uploadPostImage(text: textController.text, dateTime: now.toString());
                }
            }, child: Text("Post")),
          ],
        ),
             body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
            children: [
              if(state is SocialCreatePostLoadingState)
                LinearProgressIndicator(),
              if(state is SocialCreatePostLoadingState)
                SizedBox(height: 10,),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(SocialCubit.get(context).userModel!.image.toString()),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text("Mohamed Amr"),
                  ),
                ],
              ),
              Expanded(
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                  hintText:postImage!=null?"Say something about this photo...": "What's on your mind? ",
                  border: InputBorder.none,

                ),),
              ),
              SizedBox(height: 20,),
              if(SocialCubit.get(context).postImage!=null)
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:FileImage(File(postImage!.path)) ),
                   ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 18,
                        child: IconButton(onPressed: (){
                         SocialCubit.get(context).removePostImage();
                        }, icon: Icon(Icons.close,size: 15,))),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextButton(onPressed: (){
                      SocialCubit.get(context).getPostImage();
                    }, child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(IconBroken.Image),
                        SizedBox(width: 5,),
                        Text("add photos"),
                      ],
                    )),
                  ),
                  Expanded(
                    child: TextButton(onPressed: (){}, child:
                    Text("# tags")),
                  )
                ],
              )
            ],
          ),
        ),
      );}

    );
  }
}

import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/moduels/chat_image_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  var textController=TextEditingController();
   SocialUserModel? model;
  ChatDetailsScreen(this.model);
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder:(context) {
        SocialCubit.get(context)
            .getMessages(receiverId: model!.uId);

        return BlocConsumer<SocialCubit,SocialState>(
          listener: (context, state) {},
          builder: (context, state) {
            return
              Scaffold(

                appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:NetworkImage(model!.image.toString()),

                      ),
                      SizedBox(width: 15,),
                      Text(model!.name.toString()),
                    ],
                  ),
                ),
                body: ConditionalBuilder(
                  condition: SocialCubit.get(context).messages.length>0,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.symmetric(vertical: 15),
                           child: ListView.separated(
                               itemBuilder: (context, index)
                               {

                                 if(SocialCubit.get(context).messages[index].chatImage!=null)
                                   {
                                     if(SocialCubit.get(context).userModel!.uId==SocialCubit.get(context).messages[index].senderuId)
                                     {
                                       return  buildMyphotoMessage(SocialCubit.get(context).messages[index],context);
                                     }
                                     else
                                       return  buildphotoMessage(SocialCubit.get(context).messages[index],context);
                                   }

                                 if(SocialCubit.get(context).userModel!.uId==SocialCubit.get(context).messages[index].senderuId)
                                 {
                                   return  buildMyMessage(SocialCubit.get(context).messages[index]);
                                 }
                                 else
                                   return  buildMessage(SocialCubit.get(context).messages[index]);



                               } ,
                               separatorBuilder: (context, index) => SizedBox(height: 15,),
                               itemCount: SocialCubit.get(context).messages.length),
                         ),
                       ),
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
                                      SocialCubit.get(context).sendMessage(text:textController.text,receiverId:model!.uId ,datetime:DateTime.now().toString(),);
                                      textController.text="";
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

                                //  SocialCubit.get(context).getChatImage();
                                  navigateTo(context, ChatImageScreen(model!));
                                },
                                  minWidth: 1,
                                  child: Icon(IconBroken.Camera,color: Colors.blue,size: 16,),
                                ),
                              ),
                              Container(
                                height: 50,
                                color: defaultColor,
                                child: MaterialButton(onPressed: (){

                                  SocialCubit.get(context).sendMessage(text:textController.text,receiverId:model!.uId ,datetime:DateTime.now().toString());
                                  textController.text="";
                                },
                                  minWidth: 1,
                                  child: Icon(IconBroken.Send,color: Colors.white,size: 16,),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator()),
                ),
              );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel message)=>Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(

        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd:Radius.circular(15),
              topEnd: Radius.circular(15),
              topStart: Radius.circular(15)
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10
        ),
        child: Text(message.text.toString())
    ),
  );
  Widget buildMyMessage(MessageModel message)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(

        decoration: BoxDecoration(
          color: defaultColor.withOpacity(.2),
          borderRadius: BorderRadiusDirectional.only(
              bottomStart:Radius.circular(15),
              topEnd: Radius.circular(15),
              topStart: Radius.circular(15)
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10
        ),
        child: Text(message.text.toString())
    ),
  );
  Widget buildMyphotoMessage(MessageModel message,context)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft:Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),

        ),
        image: DecorationImage(
            fit: BoxFit.cover,
            image:NetworkImage(message.chatImage.toString())
        ),
      ),
    ),
  );
  Widget buildphotoMessage(MessageModel message,context)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft:Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),

        ),
        image: DecorationImage(
            fit: BoxFit.cover,
            image:NetworkImage(message.chatImage.toString())
        ),
      ),
    ),
  );


}


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/token_model.dart';
import 'package:social_app/moduels/agora_manager.dart';
import 'package:social_app/moduels/chat_image_screen.dart';
import 'package:social_app/moduels/vedio_call_screen.dart';
import 'package:social_app/moduels/vediocall.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  var textController=TextEditingController();
   SocialUserModel? model;
  TokenModel? tokenModel;
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
           var userModel= SocialCubit.get(context).userModel;

            return
              Scaffold(

                appBar: AppBar(
                  actions: [
                    IconButton(onPressed: (){
                      for(int i=0;i<SocialCubit.get(context).tokens.length;i++)
                      {
                        if(SocialCubit.get(context).tokens[i].uId==model!.uId)
                        {
                          print(model!.uId);
                          print(model!.name
                          );

                          SocialCubit.get(context).sendPushMessage(token:SocialCubit.get(context).tokens[i].token
                              ,body:"Caling..." ,title:userModel!.name,model: userModel,click:"vedio",channelName:AgoraManager.channelName,
                            channelToken: AgoraManager.token
                          );
                          print(SocialCubit.get(context).tokens[i].token);
                        }
                      }
                      navigateTo(context, VideoCall(AgoraManager.channelName,AgoraManager.token));
                    }, icon: Icon(Icons.video_call,size: 30,)),
                  ],
                  titleSpacing: 0.0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:NetworkImage(model!.image.toString()),

                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Text(model!.name.toString())),
                    ],
                  ),
                ),
                body: ConditionalBuilder(
                  //SocialCubit.get(context).messages.length>0,
                  condition: true,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.symmetric(vertical: 15),
                           child: ListView.separated(
                              reverse: true,
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
                                      for(int i=0;i<SocialCubit.get(context).tokens.length;i++)
                                      {
                                        if(SocialCubit.get(context).tokens[i].uId==model!.uId)
                                        {
                                          print(model!.uId);
                                          print(model!.name
                                          );

                                          SocialCubit.get(context).sendMessage(text:textController.text,receiverId:model!.uId ,datetime:DateTime.now().toString());
                                          SocialCubit.get(context).sendPushMessage(token:SocialCubit.get(context).tokens[i].token
                                              ,body:textController.text ,title:userModel!.name,model: userModel,click:"chat",channelName:AgoraManager.channelName,
                                              channelToken: AgoraManager.token );
                                          textController.text="";
                                          print(SocialCubit.get(context).tokens[i].token);
                                        }
                                      }
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
                                  for(int i=0;i<SocialCubit.get(context).tokens.length;i++)
                                  {
                                    if(SocialCubit.get(context).tokens[i].uId==model!.uId)
                                    {
                                      SocialCubit.get(context).sendMessage(text:textController.text,receiverId:model!.uId ,datetime:DateTime.now().toString());
                                      SocialCubit.get(context).sendPushMessage(token:SocialCubit.get(context).tokens[i].token
                                          ,body:textController.text ,title:userModel!.name,model: userModel,click:"chat",channelName:AgoraManager.channelName,
                                          channelToken: AgoraManager.token);
                                        textController.text="";
                                        print(SocialCubit.get(context).tokens[i].token);
                                    }
                                  }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text.toString()),
            SizedBox(height: 5,),
            Text(message.dateTime.toString(),style:TextStyle(color: Colors.grey,fontSize: 10),),
          ],
        )
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
        child: Column(
             crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text.toString()),
            SizedBox(height: 5,),
            Text(message.dateTime.toString(),style:TextStyle(color: Colors.grey,fontSize: 10),),


          ],
        )
    ),
  );
  Widget buildMyphotoMessage(MessageModel message,context)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft:Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),

        ),
        image: DecorationImage(
            fit: BoxFit.fill,
            image:NetworkImage(message.chatImage.toString())
        ),
      ),
    ),
  );
  Widget buildphotoMessage(MessageModel message,context)=> Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft:Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),

        ),
        image: DecorationImage(
            fit: BoxFit.fill,
            image:NetworkImage(message.chatImage.toString())
        ),
      ),
    ),
  );




}

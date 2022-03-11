import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/moduels/chat_detaials_screen.dart';
import 'package:social_app/shared/components.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>
      ( listener:(context, state) {},
       builder: (context, state) =>
           ConditionalBuilder(
             condition:SocialCubit.get(context).users.length>0 ,
             builder: (context) => ListView.separated(
                 physics: BouncingScrollPhysics(),
                 itemBuilder: (context, index) => buildChatItem(SocialCubit.get(context).users[index],context),
                 separatorBuilder: (context, index) => Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Divider(
                     height: 1,
                     color: Colors.grey,
                   ),
                 ) ,
                 itemCount: SocialCubit.get(context).users.length),
             fallback: (context) => Center(child: CircularProgressIndicator()),
           ),
    );


  }
  Widget  buildChatItem(SocialUserModel userModel,context)
  {
    return InkWell(
      onTap: (){
        navigateTo(context, ChatDetailsScreen(userModel));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userModel.image.toString()),
            ),
            SizedBox(
              width: 15,
            ),
            Text(userModel.name.toString()),
            SizedBox(
              width: 3,
            ),
          ],
        ),
      ),
    );
  }
}

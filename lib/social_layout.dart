import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/moduels/newpost_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

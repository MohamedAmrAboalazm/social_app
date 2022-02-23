import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context, state) {},
      builder: (context, state)
      {
            var userModel=SocialCubit.get(context).model;
           return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 210,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(userModel!.cover.toString()))),
                      ),
                      alignment: AlignmentDirectional.topCenter,
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            userModel!.image.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Text(userModel!.name.toString(), style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,),
              SizedBox(height: 5,),
              Text(userModel!.bio.toString(), style: Theme
                  .of(context)
                  .textTheme
                  .caption,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text("500", style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,),
                            SizedBox(height: 5,),
                            Text("Posts", style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text("500", style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,),
                            SizedBox(height: 5,),
                            Text("Posts", style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text("500", style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,),
                            SizedBox(height: 5,),
                            Text("Posts", style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text("500", style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,),
                            SizedBox(height: 5,),
                            Text("Posts", style: Theme
                                .of(context)
                                .textTheme
                                .caption,),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: (){}, child: Text("Add photos"))),
             SizedBox(width: 10,),
             OutlinedButton(onPressed: (){}, child:Icon(IconBroken.Edit,size: 16,)),
                ],
              ),
            ],
          ),
        );
      }

    );
  }
}
import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context, state){

      },
      builder: (context, state) {
        return ConditionalBuilder(
         //
          condition:SocialCubit.get(context).posts.length>0&&SocialCubit.get(context).userModel!=null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        image: NetworkImage(
                            "https://img.freepik.com/free-photo/positive-african-american-girl-points-thumb-demonstrates-copy-space-blank-pink-wall-has-happy-friendly-expression-dressed-casually-poses-indoor-suggests-going-right-says-follow-this-direction_273609-42167.jpg?size=626&ext=jpg&uid=R64849170&ga=GA1.2.89529548.1645201593"),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("communicate with friends",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],index,context),
                    separatorBuilder: (context, index) => SizedBox(height: 5,),
                    itemCount: SocialCubit.get(context).posts.length),
                SizedBox(height:5),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }





  Widget buildPostItem(PostModel model,index,context) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.symmetric(horizontal: 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(model.image.toString()),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(model.name.toString()),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          model.dateTime.toString(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 16,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Text(
              model.text.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: Container(
                          height: 25,
                          child: MaterialButton(
                            onPressed: () {},
                            minWidth: 1.0,
                            padding: EdgeInsets.zero,
                            child: Text(
                              "#softwere",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: Container(
                          height: 25,
                          child: MaterialButton(
                            onPressed: () {},
                            minWidth: 1.0,
                            padding: EdgeInsets.zero,
                            child: Text(
                              "#softwere",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: Container(
                          height: 25,
                          child: MaterialButton(
                            onPressed: () {},
                            minWidth: 1.0,
                            padding: EdgeInsets.zero,
                            child: Text(
                              "#softwere",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(model.postImage!="")
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          model.postImage.toString()))),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            SocialCubit.get(context).Likes[index].toString(),
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "0 comment",
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                                SocialCubit.get(context).userModel!.image.toString()
                                ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'write a comment ...',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context).CommentPost(SocialCubit.get(context).postId[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: InkWell(
                      onTap: () {
                        SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Like",
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

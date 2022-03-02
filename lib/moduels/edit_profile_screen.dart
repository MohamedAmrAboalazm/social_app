import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/cubit/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController=TextEditingController();
  var bioController=TextEditingController();
  var phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var userModel=SocialCubit.get(context).userModel;
        var profileImage=SocialCubit.get(context).profileImage;
        var coverImage=SocialCubit.get(context).coverImage;
        nameController.text=userModel!.name.toString();
        bioController.text=userModel!.bio.toString();
        phoneController.text=userModel!.phone.toString();
        return Scaffold(
        appBar:defaultAppBar(
          context: context,
          title: "Edit Profile",
          actions:[
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 15),
              child: TextButton(onPressed: (){
                SocialCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
              }, child:Text("UPDATE")),
            )
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                if(state is SocialLoadingUpdateUserDateState)
                LinearProgressIndicator(),
                if(state is SocialLoadingUpdateUserDateState)
                SizedBox(height: 10,),
                Container(
                  height: 210,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                       image:coverImage==null?NetworkImage(userModel.cover.toString()):FileImage(File(coverImage!.path)) as ImageProvider,) ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                  child: IconButton(onPressed: (){
                                    SocialCubit.get(context).getCoverImage();
                                  }, icon: Icon(IconBroken.Camera,size: 20,))),
                            ),
                          ],
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Theme
                                .of(context)
                                .scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage:profileImage==null?NetworkImage(userModel.image.toString()):FileImage(File(profileImage!.path)) as ImageProvider,
                            ),
                          ),
                          CircleAvatar(
                              radius: 20,
                              child: IconButton(onPressed: (){
                                SocialCubit.get(context).getProfileImage();
                              }, icon: Icon(IconBroken.Camera,size: 20,))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,),
                if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                Row(
                  children: [
                    if(SocialCubit.get(context).profileImage!=null)
                    Expanded(child: defaultButton(onPressed: (){
                      SocialCubit.get(context).uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    },text:"Upload Profile" )),
                    SizedBox(width: 5,),
                    if(SocialCubit.get(context).coverImage!=null)
                    Expanded(child: defaultButton(onPressed: (){
                      SocialCubit.get(context).uploadcoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                    },text:"Upload Cover" )),
                  ],
                ),
                SizedBox(
                  height: 20,),
                defaultFormField(
                    prefixicon:IconBroken.User,
                    controller: nameController ,
                    keyboardtype: TextInputType.name,
                    labelText:"Name",
                    validator: (value){
                      if(value!.isEmpty)
                        {
                          return "name must not be empty";
                        };
                      return null;
                    }),

                SizedBox(
                  height: 10,),
                defaultFormField(
                    prefixicon:IconBroken.Info_Circle,
                    controller: bioController ,
                    keyboardtype: TextInputType.text,
                    labelText:"Bio",
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "bio must not be empty";
                      };
                      return null;
                    }),
                SizedBox(
                  height: 10,),
                defaultFormField(
                    prefixicon:IconBroken.Call,
                    controller: phoneController ,
                    keyboardtype: TextInputType.phone,
                    labelText:"phone",
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "phone must not be empty";
                      };
                      return null;
                    }),

              ],
            ),
          ),
        ),

      );}
    );
  }
}

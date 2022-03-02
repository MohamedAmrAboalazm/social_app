import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/Social_user_model.dart';
import 'package:social_app/moduels/register/cubit/states.dart';
import 'package:social_app/network/local/cache_helper.dart';




class SocialRegisterCubit extends Cubit<SocialRegisterState>{
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context)=>BlocProvider.of(context);



  void userRegister({required String name,required String email,required String password,required String phone})
  {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid,);
    }).catchError((erorr){
      print(erorr.toString());
      emit(SocialRegisterErorrState(erorr.toString()));
    })
    ;

  }
  void userCreate({required String name,required String email,required String phone,required String uId,required})
  {
    SocialUserModel model=SocialUserModel(
    email:email,
    phone: phone,
    name: name,
    uId: uId,
    isEmailVerified: false,
     bio:"enter Your bio",
  image: "https://img.freepik.com/free-photo/portrait-young-beautiful-playful-woman-with-bun-posing_176420-12392.jpg?w=1060",
  cover: "https://img.freepik.com/free-photo/positive-african-american-girl-points-thumb-demonstrates-copy-space-blank-pink-wall-has-happy-friendly-expression-dressed-casually-poses-indoor-suggests-going-right-says-follow-this-direction_273609-42167.jpg?size=626&ext=jpg&uid=R64849170&ga=GA1.2.89529548.1645201593");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value){
          emit(SocialCreateUserSucessState());})
        .catchError((erorr){
          emit(SocialCreateUserErorrState(erorr.toString()));
    });
  }

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility()
  {
    isPassword=!isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(SocialChangePasswordVisibilityState());

  }
}
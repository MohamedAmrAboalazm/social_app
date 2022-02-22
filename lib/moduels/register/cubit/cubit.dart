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
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
    }).catchError((erorr){
      print(erorr.toString());
      emit(SocialRegisterErorrState(erorr.toString()));
    })
    ;

  }
  void userCreate({required String name,required String email,required String phone,required String uId})
  {
    SocialUserModel model=SocialUserModel(email:email,phone: phone,name: name,uId: uId,isEmailVerified: false);
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
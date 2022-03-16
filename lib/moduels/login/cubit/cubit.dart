

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/moduels/login/cubit/states.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/social_layout.dart';


class SocialLoginCubit extends Cubit<SocialLoginState>{
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context)=>BlocProvider.of(context);

  void userLogin({required String email,required String password,required context})
  {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .then((value) {
      print(SocialCubit.get(context).Token);
      print(value.user!.email);
      emit(SocialLoginSucessState(value.user!.uid));
    }).catchError((erorr){
      print(erorr.toString());
      emit(SocialLoginErorrState(erorr.toString()));
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
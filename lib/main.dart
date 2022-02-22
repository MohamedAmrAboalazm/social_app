import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/moduels/login/social_login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/styles/constants.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:social_app/social_layout.dart';

import 'network/local/cache_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
    uId= CacheHelper.getData(key: "uId");
  print(uId);
  runApp( MyApp(uId));
}

class MyApp extends StatelessWidget {
  var uId;
  MyApp(this.uId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>SocialCubit()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home:uId!=null? SocialLayout():SocialLoginScreen(),

      ),
    );
  }
}


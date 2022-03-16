import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/moduels/login/social_login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/styles/constants.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:social_app/social_layout.dart';
import 'network/local/cache_helper.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("on background message");
  print(message.data.toString());
  showToast(message: "on background message", state: ToastStates.SUCCES);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//  var token= await FirebaseMessaging.instance.getToken();
//  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print("On Message");
    print(event.data.toString());
    showToast(message: "On Message", state: ToastStates.SUCCES);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("on message opened app");
    print(event.data.toString());
    showToast(message: "on message opened app", state: ToastStates.SUCCES);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      create: (context) =>SocialCubit()..getUserData()..getPosts()..getTokens(),
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


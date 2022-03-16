
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/cubit.dart';
import 'package:social_app/moduels/register/social_register_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components.dart';

import '../../social_layout.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();
  var emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit,SocialLoginState>(
          listener: (context, state){
            if(state is SocialLoginErorrState)
              {
                  showToast(message: state.LoginErorr, state: ToastStates.ERORR);
              }
            if(state is SocialLoginSucessState)
              {
                CacheHelper.saveData(key: "uId", value: state.uId).then((value) {
                  navigateAndFinsh(context, SocialLayout());
                });
              }
          },
          builder: (context, state) => Scaffold(
            appBar:AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text("Login",style:
                        Theme.of(context)
                            .textTheme.headline4!.copyWith(color:Colors.black),),
                        SizedBox(height: 10,),
                        Text("Login now to communicate with friends",
                          style: Theme.of(context).textTheme.bodyText1!
                              .copyWith(color: Colors.grey),),
                        SizedBox(height: 30,),
                        defaultFormField(
                            prefixicon: Icons.email,
                            controller: emailcontroller,
                            keyboardtype: TextInputType.emailAddress,
                            labelText: 'Email Address',
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                                 SocialLoginCubit.get(context)
                                   .userLogin(email: emailcontroller.text, password: passwordcontroller.text,context: context);
                              }
                            },
                            validator: (String? value){
                              if(value!.isEmpty)
                              {
                                return "please enter your email address";
                              }
                              return null;
                            }),
                        SizedBox(height: 15,),
                        defaultFormField(

                            prefixicon: Icons.lock_outline,
                            suffixicon: SocialLoginCubit.get(context).suffix,
                            controller: passwordcontroller,
                            keyboardtype: TextInputType.visiblePassword,
                            labelText: 'Password',
                            obscuretext: SocialLoginCubit.get(context).isPassword,
                            suffixPressed:()
                            {
                              SocialLoginCubit.get(context).changePasswordVisibility();
                            },
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                                 SocialLoginCubit.get(context)
                                     .userLogin(email: emailcontroller.text, password: passwordcontroller.text,context: context);
                              }
                            },
                            validator: (String? value){
                              if(value!.isEmpty)
                              {
                                return "please enter your password ";
                              }
                              return null;
                            }),
                        SizedBox(height: 30,),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder:(context) => defaultButton(text:"Login" ,onPressed: (){
                            if(formKey.currentState!.validate())
                            {
                               SocialLoginCubit.get(context)
                               .userLogin(email: emailcontroller.text, password: passwordcontroller.text,context:context);


                            }

                          }) ,
                          fallback:(context) => Center(child: CircularProgressIndicator()) ,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Don\'t have an account?'),
                            TextButton(onPressed: (){
                              navigateTo(context, SocialRegisterScreen());
                            }, child:Text("Register Now") )

                          ],),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          )  ,
        )
    );

  }
}

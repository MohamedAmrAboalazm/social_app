
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/moduels/login/social_login_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/social_layout.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';



class SocialRegisterScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();
  var emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  var namecontroller=TextEditingController();
  var phonecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SocialRegisterCubit(),
        child: BlocConsumer<SocialRegisterCubit,SocialRegisterState>(
          listener: (context, state) {
            if(state is SocialRegisterErorrState)
            {
              showToast(message: state.erorr, state: ToastStates.ERORR);
            }
            if(state is SocialCreateUserSucessState)
            {
              navigateAndFinsh(context, SocialLayout());
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
                        Text("REGISTER",style:
                        Theme.of(context)
                            .textTheme.headline4!.copyWith(color:Colors.black),),
                        SizedBox(height: 10,),
                        Text("Register now to communicate with friends",
                          style: Theme.of(context).textTheme.bodyText1!
                              .copyWith(color: Colors.grey),),
                        SizedBox(height: 30,),
                        defaultFormField(
                            prefixicon: Icons.person,
                            controller: namecontroller,
                            keyboardtype: TextInputType.name,
                            labelText: 'User Name',
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                               SocialRegisterCubit.get(context)
                                   .userRegister(name: namecontroller.text,phone: phonecontroller.text,email: emailcontroller.text, password: passwordcontroller.text);
                              }
                            },
                            validator: (String? value){
                              if(value!.isEmpty)
                              {
                                return "please enter your name";
                              }
                              return null;
                            }),
                        SizedBox(height: 15,),
                        defaultFormField(
                            prefixicon: Icons.email,
                            controller: emailcontroller,
                            keyboardtype: TextInputType.emailAddress,
                            labelText: 'Email Address',
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                                SocialRegisterCubit.get(context)
                                   .userRegister(name: namecontroller.text,phone: phonecontroller.text,email: emailcontroller.text, password: passwordcontroller.text);
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
                            suffixicon: SocialRegisterCubit.get(context).suffix,
                            controller: passwordcontroller,
                            keyboardtype: TextInputType.visiblePassword,
                            labelText: 'Password',
                            obscuretext: SocialRegisterCubit.get(context).isPassword,
                            suffixPressed:()
                            {
                              SocialRegisterCubit.get(context).changePasswordVisibility();
                            },
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                                SocialRegisterCubit.get(context)
                                    .userRegister(name: namecontroller.text,phone: phonecontroller.text,email: emailcontroller.text, password: passwordcontroller.text);
                              }
                            },
                            validator: (String? value){
                              if(value!.isEmpty)
                              {
                                return "please enter your password ";
                              }
                              return null;
                            }),
                        SizedBox(height: 15,),
                        defaultFormField(

                            prefixicon: Icons.phone,
                            controller: phonecontroller,
                            keyboardtype: TextInputType.number,
                            labelText: 'phone',
                            submitt: (value){
                              if(formKey.currentState!.validate())
                              {
                                SocialRegisterCubit.get(context)
                                    .userRegister(name: namecontroller.text,phone: phonecontroller.text,email: emailcontroller.text, password: passwordcontroller.text);
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
                          condition: state is! SocialRegisterLoadingState,
                          builder:(context) => defaultButton(text:"Rigester" ,onPressed: (){
                            if(formKey.currentState!.validate())
                            {
                                SocialRegisterCubit.get(context)
                                  .userRegister(name: namecontroller.text,phone: phonecontroller.text,email: emailcontroller.text, password: passwordcontroller.text);

                            }

                          }) ,
                          fallback:(context) => Center(child: CircularProgressIndicator()) ,
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Do have an account?'),
                            TextButton(onPressed: (){
                              navigateTo(context, SocialLoginScreen());
                            }, child:Text("Login Now") )

                          ],),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}

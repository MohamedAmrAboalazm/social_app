
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/moduels/login/social_login_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';


Widget buildArticleItem(article,context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
                '${article["urlToImage"]}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        child: Container(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${article['title']}',
                  style:Theme.of(context).textTheme.bodyText1,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${article['publishedAt']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      )
    ],
  ),
);

Widget articleBuilder(list,context,{isSearch=false})=>ConditionalBuilder(
  condition: list.length>0 ,
  builder: (context)=>
      ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>buildArticleItem(list[index],context),
          separatorBuilder:(context, index) => Container(
            width:double.infinity,
            height: 1,
            color: Colors.grey[300],),
          itemCount:list.length),
  fallback:(context)=>isSearch ? Container(): Center(child: CircularProgressIndicator())
  ,);


Widget defaultFormField(
    {required IconData  prefixicon,
      required TextEditingController controller,
      required TextInputType keyboardtype,
      IconData? suffixicon,
     void  Function()? onTap,
      bool obscuretext = false,
      bool isClickable = true,
      required String  labelText,
      required String?  Function(String?) validator,
      void Function(String)? submitt,
       void Function (String)?   onChange,
     void  Function()? suffixPressed,

    }) {
  return TextFormField(
    onFieldSubmitted: submitt,
    enabled: isClickable,
    onTap: onTap,
    onChanged: onChange,
    controller: controller,
    keyboardType: keyboardtype,
    validator: validator,
    obscureText: obscuretext,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixicon),
      suffixIcon: suffixicon != null ?IconButton(onPressed:suffixPressed,icon: Icon(suffixicon)) : null,
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  );
}
Widget defaultButton({String? text,required void Function()? onPressed,})=>Container(
  width: double.infinity,
  decoration: BoxDecoration(
    color: defaultColor,
    borderRadius: BorderRadius.circular(5),
  ),
  child: MaterialButton(
    
      onPressed: onPressed,
    child: Text(text!.toUpperCase(),style:TextStyle(color: Colors.white),),
  ),
);

PreferredSizeWidget defaultAppBar({required BuildContext context, String? title, List<Widget>? actions})
=>AppBar(
  titleSpacing: 0.0,
  leading: IconButton(
    icon:Icon(IconBroken.Arrow___Left_2),
    onPressed: (){Navigator.pop(context);
    },
  ),
  title: Text(title!),
  actions: actions,
);

void navigateTo(context,widget)=>Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=>widget
    )
);

void navigateAndFinsh(context,widget)=>Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=> widget,),
        (route) => false);

void showToast({required String message,required ToastStates state}){
  Fluttertoast.showToast(
      msg:message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor:chosseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );

}

   enum ToastStates {SUCCES,ERORR,WARNING}
   Color chosseToastColor(ToastStates state)
   {
     Color color;
     switch(state)
     {
       case ToastStates.SUCCES:
         color=Colors.green;
          break;
       case ToastStates.ERORR:
         color=Colors.red;
         break;
       case ToastStates.WARNING:
         color=Colors.amber;
         break;
     }
     return color;


   }

   void signOut(context){
     CacheHelper.removeData(key: "uId").then((value)
     {
       navigateAndFinsh(context, SocialLoginScreen());
     });
   }

Widget buildListProduct( model,context,{bool isOldPrice=true,String? text})
{
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120,
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                      model.image),
                  width: 120,
                  height: 120,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.red,
                    // ignore: prefer_const_constructors
                    child: Text(
                      'DISCOUNT',
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0 && isOldPrice)
                      Text(
                        model.oldPrice.toString(),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          //ShopCubit.get(context).changeFavourite(model.id,text: text);
                        },
                        icon: CircleAvatar(
                            radius: 15,
                          //  backgroundColor:ShopCubit.get(context).Favourites[model.id]?defaultColor:Colors.grey,
                            // ignore: prefer_const_constructors
                            child: Icon(
                              Icons.favorite_border,
                              size: 14,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}






import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {

   static  Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://fcm.googleapis.com/",
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type':'application/json',
          "Authorization":"key=AAAA02h14ew:APA91bG7rvrJpbxTQfNLe0a9j1nVoJ8ULiMpDRriwELzBmM6Ig36wMh1y5muIl5Nmu_0pJVKcgY9GyrJ-DnUtyTQMeGTs_pCi1FloZ2fev7sgzculyBKmX48L7w1lDVcaZXxigtnlnNg",
        }
      ),
    );
  }
  static Future<Response>  postData({
    required String url,
    required Map<String,dynamic> data,
  }) async{
    return await dio!.post(url,data: data);
  }

}
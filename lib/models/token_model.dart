class TokenModel
{

   String? token;
   String? uId;

  TokenModel({this.token,this.uId});

  TokenModel.fromJson( Map<String,dynamic>? json)
  {
    token=json?["token"];
    uId=json?["uId"];
  }
  Map<String,dynamic> toMap()
  {
    return
      {
        "token":token,
        "uId":uId,

      };
  }

}

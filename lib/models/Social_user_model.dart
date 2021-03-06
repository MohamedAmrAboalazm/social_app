class SocialUserModel
{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? bio;
  String? cover;
  bool? isEmailVerified;


  SocialUserModel({this.name, this.email, this.phone, this.uId,this.isEmailVerified,this.image,this.bio,this.cover});

  SocialUserModel.fromJson( Map<String,dynamic>? json)
  {
    name=json?["name"];
    email=json?["email"];
    phone=json?["phone"];
    uId=json?["uId"];
    image=json?["image"];
    bio=json?["bio"];
    cover=json?["cover"];
    isEmailVerified=json?["isEmailVerified"];

  }
  Map<String,dynamic> toMap()
  {
    return
      {
         "name":name,
         "email":email,
         "phone":phone,
         "uId":uId,
         "image":image,
         "bio":bio,
         "cover":cover,
         "isEmailVerified":isEmailVerified,
    };
  }

}

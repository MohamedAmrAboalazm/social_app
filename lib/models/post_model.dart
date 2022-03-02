class PostModel
{
  String? name;
  String? postImage;
  String? text;
  String? dateTime;
  String? uId;
  String? image;


  PostModel({this.name, this.postImage, this.text, this.uId,this.dateTime,this.image});

  PostModel.fromJson( Map<String,dynamic>? json)
  {
    name=json?["name"];
    uId=json?["uId"];
    image=json?["image"];
    postImage=json?["postImage"];
    text=json?["text"];
    dateTime=json?["dateTime"];
  }
  Map<String,dynamic> toMap()
  {
    return
      {
        "name":name,
        "uId":uId,
        "image":image,
        "postImage":postImage,
        "text":text,
        "dateTime":dateTime,


      };
  }

}

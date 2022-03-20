class Call {
  String? callerId;
  String? callerName;
  String? callerPic;
  String?receiverId;
  String?receiverName;
  String?receiverPic;
  String?channelId;
  bool? hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled,
  });

  Call.fromJson(Map<String,dynamic>? json)
  {
    callerId=json?["callerId"];
    callerName=json?["callerName"];
    callerPic=json?["callerPic"];
    receiverId=json?["receiverId"];
    receiverName=json?["receiverName"];
    receiverPic=json?["receiverPic"];
    channelId=json?["channelId"];
    hasDialled=json?["hasDialled"];

  }

  // to map
  Map<String, dynamic> toMap() {
   return
     {
       "callerId": callerId,
       "callerName": callerName,
       "callerPic": callerPic,
       "receiverId": receiverId,
       "receiverName": receiverName,
       "receiverPic": receiverPic,
       "channelId": channelId,
       "hasDialled": hasDialled,

     };
  }


}
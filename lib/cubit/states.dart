abstract class SocialState{}

class SocialInitialState extends SocialState{}

class SocialGetUserLoadingState extends SocialState{}

class SocialGetUserSuccessState extends SocialState{}

class SocialGetUserErorrState extends SocialState{
  final String erorr;

  SocialGetUserErorrState(this.erorr);
}

class SocialGetPostsLoadingState extends SocialState{}

class SocialGetPostsSuccessState extends SocialState{}

class SocialGetPostsErorrState extends SocialState{
  final String erorr;

  SocialGetPostsErorrState(this.erorr);
}

class SocialLikePostSuccessState extends SocialState{}

class SocialLikePostErorrState extends SocialState{
  final String erorr;

  SocialLikePostErorrState(this.erorr);
}

class SocialChangeBottomNavState extends SocialState{}

class SocialNewPostState extends SocialState{}

class SocialProfileImagePickedSucessState extends SocialState{}

class SocialProfileImagePickedErorrState extends SocialState{}

class SocialCoverImagePickedSucessState extends SocialState{}

class SocialCoverImagePickedErorrState extends SocialState{}

class SocialUploadProfileImageSucessState extends SocialState{}

class SocialUploadProfileImageErorrState extends SocialState{}

class SocialUpdateUserDateErorrState extends SocialState{}

class SocialLoadingUpdateUserDateState extends SocialState{}

class SocialCreatePostLoadingState extends SocialState{}

class SocialCreatePostSucessState extends SocialState{}

class SocialCreatePostErorrState extends SocialState{}

class SocialPostImagePickedErorrState extends SocialState{}

class SocialPostImagePickedSucessState extends SocialState{}

class SocialRemovePostImageState extends SocialState{}

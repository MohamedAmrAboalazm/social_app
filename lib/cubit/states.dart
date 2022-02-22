abstract class SocialState{}

class SocialInitialState extends SocialState{}

class SocialGetUserLoadingState extends SocialState{}

class SocialGetUserSuccessState extends SocialState{}

class SocialGetUserErorrState extends SocialState{
  final String erorr;

  SocialGetUserErorrState(this.erorr);
}

class SocialChangeBottomNavState extends SocialState{}

class SocialNewPostState extends SocialState{}



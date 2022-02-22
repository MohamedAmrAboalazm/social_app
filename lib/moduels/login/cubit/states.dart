abstract class SocialLoginState{}

class SocialLoginInitialState extends SocialLoginState{}

class SocialLoginLoadingState extends SocialLoginState{}

class SocialLoginSucessState extends SocialLoginState{
  final uId;

  SocialLoginSucessState(this.uId);
}

class SocialChangePasswordVisibilityState extends SocialLoginState{}

class SocialLoginErorrState extends SocialLoginState {
  final LoginErorr;

  SocialLoginErorrState(this.LoginErorr);
}

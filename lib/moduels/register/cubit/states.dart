

abstract class SocialRegisterState{}

class SocialRegisterInitialState extends SocialRegisterState{}

class SocialRegisterLoadingState extends SocialRegisterState{}

class SocialRegisterSucessState extends SocialRegisterState{}

class SocialRegisterErorrState extends SocialRegisterState {
  final erorr;

  SocialRegisterErorrState(this.erorr);
}

class SocialChangePasswordVisibilityState extends SocialRegisterState{}

class SocialCreateUserSucessState extends SocialRegisterState{}

class SocialCreateUserErorrState extends SocialRegisterState{
  final erorr;

  SocialCreateUserErorrState(this.erorr);
}
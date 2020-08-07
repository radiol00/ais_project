part of 'authgate_bloc.dart';

@immutable
abstract class AuthgateEvent extends Equatable {}

class AuthgateLogin extends AuthgateEvent {
  AuthgateLogin({this.email, this.password});
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
}

class AuthgateTryToVerifyJWT extends AuthgateEvent {
  @override
  List<Object> get props => [];
}

class AuthgateLogout extends AuthgateEvent {
  @override
  List<Object> get props => [];
}

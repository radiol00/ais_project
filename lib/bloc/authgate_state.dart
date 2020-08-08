part of 'authgate_bloc.dart';

@immutable
abstract class AuthgateState extends Equatable {}

class AuthgateInitial extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateUnauthorized extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateLoading extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateAppLoading extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateAuthorized extends AuthgateState {
  AuthgateAuthorized({this.repo});
  final AISRepository repo;
  @override
  List<Object> get props => [repo];
}

class AuthgateError extends AuthgateState {
  AuthgateError({this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

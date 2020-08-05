part of 'authgate_bloc.dart';

@immutable
abstract class AuthgateState extends Equatable {}

class AuthgateInitial extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateLoading extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateAuthorized extends AuthgateState {
  @override
  List<Object> get props => [];
}

class AuthgateError extends AuthgateState {
  AuthgateError({this.message, this.errorPlaceTag});
  final String message;
  final String errorPlaceTag;
  @override
  List<Object> get props => [message, errorPlaceTag];
}

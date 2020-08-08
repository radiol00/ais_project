import 'dart:async';

import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ais_project/models/user_model.dart';

part 'authgate_event.dart';
part 'authgate_state.dart';

class AuthgateBloc extends Bloc<AuthgateEvent, AuthgateState> {
  AuthgateBloc() : super(AuthgateAppLoading());

  AISRepository _repo = AISRepository();
  @override
  Stream<AuthgateState> mapEventToState(
    AuthgateEvent event,
  ) async* {
    if (event is AuthgateTryToVerifyJWT) {
      yield AuthgateAppLoading();
      dynamic user = await _repo.init();
      if (user is User) {
        yield AuthgateAuthorized(repo: _repo);
      } else {
        yield AuthgateInitial();
      }
    } else if (event is AuthgateLogin) {
      yield AuthgateLoading();
      dynamic user = await _repo.login(event.email, event.password);
      if (user is User) {
        yield AuthgateAuthorized(repo: _repo);
      } else {
        yield AuthgateError(message: 'Wystąpił błąd podczas logowania');
      }
    } else if (event is AuthgateLogout) {
      yield AuthgateAppLoading();
      bool success = await _repo.logout();
      if (success) {
        yield AuthgateInitial();
      } else {
        yield AuthgateAuthorized();
      }
    }
  }
}

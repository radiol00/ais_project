import 'dart:async';

import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ais_project/repository/ais_repository_dispatchers.dart';

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
      bool success = await _repo.init();
      if (success) {
        yield AuthgateAuthorized(repo: _repo);
      } else {
        yield AuthgateInitial();
      }
    } else if (event is AuthgateLogin) {
      yield AuthgateLoading();
      bool success = await _repo
          .dispatch(RepoLogin(email: event.email, password: event.password));
      if (success) {
        yield AuthgateAuthorized(repo: _repo);
      } else {
        yield AuthgateError(message: 'Wystąpił błąd podczas logowania');
      }
    } else if (event is AuthgateLogout) {
      yield AuthgateAppLoading();
      bool success = await _repo.dispatch(RepoLogout());
      if (success) {
        yield AuthgateInitial();
      } else {
        yield AuthgateAuthorized();
      }
    }
  }
}

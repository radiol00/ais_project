import 'dart:async';

import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'authgate_event.dart';
part 'authgate_state.dart';

class AuthgateBloc extends Bloc<AuthgateEvent, AuthgateState> {
  AuthgateBloc() : super(AuthgateInitial());

  AISRepository _repo = AISRepository();
  @override
  Stream<AuthgateState> mapEventToState(
    AuthgateEvent event,
  ) async* {
    if (event is AuthgateTryToVerifyJWT) {
      yield AuthgateLoading();
      bool success = await _repo.init();
      if (success) {
        yield AuthgateAuthorized();
      } else {
        yield AuthgateInitial();
      }
    }
    if (event is AuthgateLogin) {
      yield AuthgateLoading();
      bool success = await _repo.login(event.email, event.password);
      if (success) {
        yield AuthgateAuthorized();
      } else {
        yield AuthgateError(message: 'Wystąpił błąd podczas logowania');
      }
    }
  }
}

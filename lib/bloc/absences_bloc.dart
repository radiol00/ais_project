import 'dart:async';

import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ais_project/repository/ais_repository_dispatchers.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesBloc({@required this.repo, @required this.authgateBloc})
      : super(AbsencesLoading());
  final AISRepository repo;
  final AuthgateBloc authgateBloc;

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is AbsencesGet) {
      dynamic result = await repo.dispatch(RepoGetUserAbsences());
      if (result is List<Absence>) {
        yield AbsencesLoaded(absences: result);
      } else if (result is RepoDispatchingNotPossible) {
        authgateBloc.add(AuthgateLogout());
      } else {
        yield AbsencesError();
      }
    } else if (event is AbsencesAdd) {
      final result =
          await repo.dispatch(RepoAddAbsence(absence: event.absence));
      if (result == true) {
        final absences = await repo.dispatch(RepoGetUserAbsences());
        if (absences is List<Absence>) {
          yield AbsencesLoaded(absences: absences);
        } else if (absences is RepoDispatchingNotPossible) {
          authgateBloc.add(AuthgateLogout());
        } else {
          yield AbsencesError();
        }
      } else if (result is RepoDispatchingNotPossible) {
        authgateBloc.add(AuthgateLogout());
      } else {
        yield AbsencesError();
      }
    }
  }
}

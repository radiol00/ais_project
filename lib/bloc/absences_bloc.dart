import 'dart:async';

import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ais_project/repository/ais_repository_dispatchers.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesBloc({@required this.repo}) : super(AbsencesLoading());
  final AISRepository repo;

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is AbsencesGet) {
      dynamic result = await repo.dispatch(RepoGetUserAbsences());
      if (result is List<Absence>) {
        yield AbsencesLoaded(absences: result);
      } else {
        yield AbsencesError();
      }
    } else if (event is AbsencesAdd) {
      final success =
          await repo.dispatch(RepoAddAbsence(absence: event.absence));
      if (success == true) {
        final absences = await repo.dispatch(RepoGetUserAbsences());
        if (absences is List<Absence>) {
          yield AbsencesLoaded(absences: absences);
        } else {
          yield AbsencesError();
        }
      } else {
        yield AbsencesError();
      }
    }
  }
}

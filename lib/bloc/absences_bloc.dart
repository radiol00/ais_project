import 'dart:async';

import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

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
      final absences = await repo.getUserAbsences();
      if (absences is List<Absence>) {
        yield AbsencesLoaded(absences: absences);
      } else {
        yield AbsencesError();
      }
    } else if (event is AbsencesAdd) {
      final success = await repo.addAbsence(event.absence);
      if (success) {
        final absences = await repo.getUserAbsences();
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

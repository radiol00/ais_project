part of 'absences_bloc.dart';

@immutable
abstract class AbsencesEvent extends Equatable {}

class AbsencesGet extends AbsencesEvent {
  @override
  List<Object> get props => [];
}

class AbsencesAdd extends AbsencesEvent {
  AbsencesAdd({this.absence});
  final Absence absence;

  @override
  List<Object> get props => [absence];
}

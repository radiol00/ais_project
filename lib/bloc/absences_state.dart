part of 'absences_bloc.dart';

@immutable
abstract class AbsencesState extends Equatable {}

class AbsencesLoading extends AbsencesState {
  @override
  List<Object> get props => [];
}

class AbsencesLoaded extends AbsencesState {
  AbsencesLoaded({this.absences});
  final List<Absence> absences;

  @override
  List<Object> get props => [absences];
}

class AbsencesError extends AbsencesState {
  @override
  List<Object> get props => [];
}

import 'package:ais_project/models/absence_model.dart';

abstract class RepoAction {}

class RepoLogin extends RepoAction {
  RepoLogin({this.email, this.password});
  final String email;
  final String password;
}

class RepoLogout extends RepoAction {}

class RepoGetUserAbsences extends RepoAction {}

class RepoAddAbsence extends RepoAction {
  RepoAddAbsence({this.absence});
  final Absence absence;
}

class RepoDispatchingNotPossible {}

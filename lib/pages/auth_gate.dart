import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/pages/home_page.dart';
import 'package:ais_project/pages/hello_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthgateBloc _bloc = AuthgateBloc();

  @override
  void initState() {
    _bloc.add(AuthgateTryToVerifyJWT());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is AuthgateAppLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AuthgateAuthorized) {
            return HomePage(
              user: state.user,
            );
          }
          return HelloPage();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

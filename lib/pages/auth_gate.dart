import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatefulWidget {
  AuthGate({@required this.authChild, @required this.notAuthChild});
  final Widget authChild;
  final Widget notAuthChild;
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
          if (state is AuthgateAuthorized) {
            return widget.authChild;
          }
          return widget.notAuthChild;
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

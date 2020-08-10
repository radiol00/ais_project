import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/pages/home_page.dart';
import 'package:ais_project/pages/hello_page.dart';
import 'package:ais_project/styling/palette.dart';
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
          Widget _buildBloc(context, state) {
            if (state is AuthgateAppLoading) {
              return Scaffold(
                body: SizedBox.expand(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Palette.aisred, Palette.scaffoldBackground],
                      ),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            }
            if (state is AuthgateAuthorized) {
              return HomePage(
                repo: state.repo,
              );
            }
            return HelloPage();
          }

          return AnimatedSwitcher(
            switchOutCurve: Threshold(0),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
                  .animate(animation),
              child: child,
            ),
            duration: Duration(seconds: 1),
            child: _buildBloc(context, state),
          );
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

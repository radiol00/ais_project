import 'package:ais_project/bloc/absences_bloc.dart';
import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:ais_project/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.repo, @required this.authgateBloc});
  final AISRepository repo;
  final AuthgateBloc authgateBloc;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AbsencesBloc _bloc;
  User user;
  @override
  void initState() {
    _bloc = AbsencesBloc(repo: widget.repo, authgateBloc: widget.authgateBloc);
    _bloc.add(AbsencesGet());
    user = widget.repo.getUser();
    super.initState();
  }

  Widget _buildDrawer(context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Palette.appbar,
                child: SafeArea(
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('AIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    BlocProvider.of<AuthgateBloc>(context)
                        .add(AuthgateLogout());
                  },
                  child: Text('Wyloguj'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            splashRadius: 20,
          ),
        ),
        body: Column(
          children: [
            BlocBuilder(
              bloc: _bloc,
              builder: (context, state) {
                if (state is AbsencesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AbsencesLoaded) {
                  return Center(
                    child: Text('${state.absences}'),
                  );
                } else if (state is AbsencesError) {
                  return Center(
                    child: Text('error'),
                  );
                }
                return Center();
              },
            ),
            RaisedButton(
              onPressed: () {
                _bloc.add(AbsencesAdd(
                    absence: Absence(
                        startDate: DateTime(2020),
                        endDate: DateTime(2020),
                        additionalInfo: 'raz',
                        reason: 'dwa')));
              },
              child: Text('dodaj'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}

import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:ais_project/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({this.user});
  final User user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDrawer(context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
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
            )
          ]),
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
        body: Container(
          child: SafeArea(
            child: Text(widget.user.email),
          ),
        ),
      ),
    );
  }
}

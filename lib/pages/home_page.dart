import 'package:ais_project/bloc/authgate_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
      ),
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
    );
  }
}

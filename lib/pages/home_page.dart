import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/pages/absence_page.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:ais_project/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.repo});
  final AISRepository repo;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  User user;

  static Widget _mainFAB = FloatingActionButton(
    onPressed: () {},
    child: Text('MAIN'),
  );

  static Widget _absencesFAB = FloatingActionButton(
    onPressed: () {},
    child: Text('ABS'),
  );

  Widget _currentFAB = _mainFAB;

  String currentRoute = '/';
  String appBarRouteName = 'Strona główna';

  @override
  void initState() {
    user = widget.repo.getUser();
    super.initState();
  }

  Widget _buildListTile({
    String routeName,
    String title,
    Icon icon,
  }) {
    return ListTile(
      selected: currentRoute == routeName,
      leading: icon,
      title: Text(title),
      onTap: () {
        if (currentRoute != routeName) {
          setState(() {
            appBarRouteName = title;
            currentRoute = routeName;
            routeName == '/'
                ? _currentFAB = _mainFAB
                : routeName == '/my_absences'
                    ? _currentFAB = _absencesFAB
                    : _currentFAB = _mainFAB;
          });
          Navigator.pop(context);
          _navigatorKey.currentState.pushReplacementNamed(routeName);
        }
      },
    );
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  thickness: 3,
                  height: 20,
                ),
              ),
              _buildListTile(
                  routeName: '/',
                  icon: Icon(Icons.home),
                  title: 'Strona główna'),
              _buildListTile(
                  routeName: '/my_absences',
                  icon: Icon(Icons.event_busy),
                  title: 'Moje nieobecności'),
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
      child: WillPopScope(
        onWillPop: () {
          //TODO: HISTORIA KORZYSTANIA
        },
        child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: _currentFAB,
            drawer: _buildDrawer(context),
            appBar: AppBar(
              title: Text(appBarRouteName),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                splashRadius: 20,
              ),
            ),
            body: Navigator(
              initialRoute: '/',
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return MaterialPageRoute(
                      builder: (context) => Material(
                        child: Center(
                          child: Text('Strona główna, ogłoszenia?'),
                        ),
                      ),
                    );
                  case '/my_absences':
                    return MaterialPageRoute(
                        builder: (context) => AbsencePage(
                              repo: widget.repo,
                            ));
                  default:
                    return MaterialPageRoute(
                      builder: (context) {
                        return Center(
                          child: Text('No such route ${settings.name}'),
                        );
                      },
                    );
                }
              },
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

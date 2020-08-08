import 'package:ais_project/bloc/authgate_bloc.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class HelloPage extends StatefulWidget {
  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  String _currentTab = 'Witaj w aplikacji zarządzającej AIS!';
  AnimationController _animationController;
  Animation<double> _animation;
  double _dotPosition = 60;
  FocusNode _passwordNode = FocusNode();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    _pageController.addListener(() {
      setState(() {
        _dotPosition = _pageController.page * 60;
      });
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
    super.initState();
  }

  void validateLoginForm(BuildContext context) {
    String error = '';

    if (_emailInput.text == '' || _passwordInput.text == '') {
      error += 'Oba pola są wymagane';
    } else {
      if (!EmailValidator.validate(_emailInput.text)) {
        error += 'Nieprawidłowy Email';
      }
    }

    if (error == '') {
      BlocProvider.of<AuthgateBloc>(context).add(AuthgateLogin(
          email: _emailInput.text, password: _passwordInput.text));
    } else {
      showToast(error);
    }
  }

  Widget buildInitialView() {
    Widget helloPage = Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/ais_logo.png',
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 260,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      color: Palette.buttons,
                      child: Text(
                        'Zaloguj się',
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                      onPressed: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );

    Widget loginPage = StyledToast(
        backgroundColor: Palette.progressIndicator,
        locale: const Locale('pl', 'PL'),
        child: Center(
          child: SingleChildScrollView(
            child: BlocListener<AuthgateBloc, AuthgateState>(
              listener: (context, state) {
                if (state is AuthgateError) {
                  showToast(state.message);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 300.0,
                        child: TextFormField(
                          controller: _emailInput,
                          onFieldSubmitted: (value) {
                            _passwordNode.requestFocus();
                          },
                          cursorColor: Palette.accentColor,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Palette.accentColor),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Palette.accentColor, width: 2))),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        width: 300.0,
                        child: TextFormField(
                          controller: _passwordInput,
                          onFieldSubmitted: (value) {
                            validateLoginForm(context);
                          },
                          focusNode: _passwordNode,
                          obscureText: true,
                          cursorColor: Palette.accentColor,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Palette.accentColor),
                              labelText: 'Hasło',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Palette.accentColor, width: 2))),
                        ),
                      ),
                      SizedBox(
                        width: 260.0,
                        child: BlocBuilder<AuthgateBloc, AuthgateState>(
                          builder: (context, state) {
                            if (state is AuthgateLoading) {
                              return Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Palette.aisred),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: Palette.buttons,
                                child: Text(
                                  'Zaloguj',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                ),
                                onPressed: () {
                                  validateLoginForm(context);
                                });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));

    Widget registrationPage = Center(
        child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  cursorColor: Palette.accentColor,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Palette.accentColor),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Palette.accentColor, width: 2))),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Palette.accentColor,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Palette.accentColor),
                      labelText: 'Hasło',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Palette.accentColor, width: 2))),
                ),
              ),
              SizedBox(
                width: 260.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Palette.buttons,
                    child: Text(
                      'Zarejestruj',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    onPressed: () {}),
              ),
            ],
          )
        ],
      ),
    ));

    Widget pageView = ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: PageView(
          onPageChanged: (value) {
            FocusScope.of(context).unfocus();
            _animationController.forward();
            _animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {
                  _currentTab = value == 0
                      ? 'Zaloguj się'
                      : value == 1
                          ? 'Witaj w aplikacji zarządzającej AIS!'
                          : 'Zarejestruj się';
                });
              }
            });
          },
          controller: _pageController,
          children: <Widget>[
            loginPage,
            helloPage,
            registrationPage,
          ],
        ));

    return Material(
      elevation: 20.0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Palette.aisred, Palette.scaffoldBackground],
        )),
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red[900]),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red[900]),
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red[900]),
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                        Positioned(
                          left: _dotPosition,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 45.0,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: Text(
                          _currentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(child: pageView)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: buildInitialView(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

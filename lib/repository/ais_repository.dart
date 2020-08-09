import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository_dispatchers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ais_project/models/user_model.dart';

class AISRepository {
  final String url = 'http://192.168.0.104:8000';
  Map jwtTokens = {'access': '', 'refresh': ''};

  User decodeTokenToUser(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return User(email: decodedToken['email'], id: decodedToken['user_id']);
  }

  User getUser() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtTokens['access']);
    return User(email: decodedToken['email'], id: decodedToken['user_id']);
  }

  Future<dynamic> dispatch(RepoAction action) async {
    // ACTIONS THAT DONT NEED JWT TOKEN
    if (action is RepoLogin) {
      return _login(action.email, action.password);
    } else if (action is RepoLogout) {
      return _logout();
    }

    // Check for access token viability
    // if access token is expired, use refresh token to refresh access token
    // if both tokens are expired return RepoDispatchingNotPossible, which should be used to logout user
    String accessToken = jwtTokens['access'];
    String refreshToken = jwtTokens['refresh'];
    if (JwtDecoder.isExpired(accessToken)) {
      if (JwtDecoder.isExpired(refreshToken))
        return RepoDispatchingNotPossible();
      final data = {'refresh': refreshToken};
      final response = await http.post('$url/auth/refresh/',
          headers: {'Content-Type': "application/json"},
          body: json.encode(data));
      if (response.statusCode == 200) {
        jwtTokens['access'] = json.decode(response.body)['access'];
        jwtTokens['refresh'] = refreshToken;
        final storage = FlutterSecureStorage();
        await storage.write(key: 'aisjwtaccess', value: jwtTokens['access']);
        return true;
      } else {
        return RepoDispatchingNotPossible();
      }
    }

    // ACTIONS THAT NEED JWT TOKEN
    if (action is RepoGetUserAbsences) {
      return _getUserAbsences();
    } else if (action is RepoAddAbsence) {
      return _addAbsence(action.absence);
    }

    throw Exception('REPO DISPATCHER: No such action!');
  }

  Future<dynamic> init() async {
    final storage = new FlutterSecureStorage();
    try {
      // Try to get tokens from secure storage
      String accessToken = await storage.read(key: 'aisjwtaccess');
      String refreshToken = await storage.read(key: 'aisjwtrefresh');

      // If there are tokens
      if (accessToken != null && refreshToken != null) {
        // If access token is expired
        if (JwtDecoder.isExpired(accessToken)) {
          // If refresh token is expired aswell - logout
          if (JwtDecoder.isExpired(refreshToken)) {
            return false;
          }
          // Refresh token
          final data = {'refresh': refreshToken};
          final response = await http.post('$url/auth/refresh/',
              headers: {'Content-Type': "application/json"},
              body: json.encode(data));

          // Successfully refreshed token
          if (response.statusCode == 200) {
            jwtTokens['access'] = json.decode(response.body)['access'];
            jwtTokens['refresh'] = refreshToken;
            return true;
          }
          // Failed to refresh
          else {
            return false;
          }
        }
        // If access token is valid
        else {
          jwtTokens['access'] = accessToken;
          jwtTokens['refresh'] = refreshToken;
          return true;
        }
      }
    } catch (e) {
      // Exception
      print(e);
      return false;
    }
    return false;
  }

  Future<dynamic> _login(String email, String password) async {
    try {
      final data = {'email': email, 'password': password};
      final response = await http.post('$url/auth/',
          headers: {'Content-Type': "application/json"},
          body: json.encode(data));
      if (response.statusCode == 200) {
        jwtTokens = json.decode(response.body);
        final storage = FlutterSecureStorage();
        await storage.write(key: 'aisjwtaccess', value: jwtTokens['access']);
        await storage.write(key: 'aisjwtrefresh', value: jwtTokens['refresh']);

        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> _getUserAbsences() async {
    try {
      final response = await http.get('$url/user/absence/', headers: {
        'Content-Type': "application/json",
        'Authorization': 'Bearer ${jwtTokens['access']}'
      });
      if (response.statusCode == 200) {
        List<Absence> absencesList = [];
        List<dynamic> absences = json.decode(response.body);
        absences.forEach((element) {
          absencesList.add(Absence.fromMap(element));
        });
        return absencesList;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _addAbsence(Absence absence) async {
    try {
      final response = await http.post('$url/absence/',
          headers: {
            'Content-Type': "application/json",
            'Authorization': 'Bearer ${jwtTokens['access']}'
          },
          body: json.encode(absence.toMap()));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _logout() async {
    try {
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'aisjwtaccess');
      await storage.delete(key: 'aisjwtrefresh');
      jwtTokens = {'access': '', 'refresh': ''};
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

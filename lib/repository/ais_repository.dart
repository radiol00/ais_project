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

  Future<dynamic> init() async {
    final storage = new FlutterSecureStorage();
    try {
      String accessToken = await storage.read(key: 'aisjwtaccess');
      String refreshToken = await storage.read(key: 'aisjwtrefresh');
      if (accessToken != null && refreshToken != null) {
        // ACCESS TOKEN EXPIRED
        if (JwtDecoder.isExpired(accessToken)) {
          final data = {'refresh': refreshToken};
          final response = await http.post('$url/auth/refresh/',
              headers: {'Content-Type': "application/json"},
              body: json.encode(data));
          if (response.statusCode == 200) {
            jwtTokens['access'] = json.decode(response.body)['access'];

            return decodeTokenToUser(jwtTokens['access']);
          }
        }
        // ACCESS TOKEN VALID
        else {
          jwtTokens['access'] = accessToken;
          jwtTokens['refresh'] = refreshToken;
          return decodeTokenToUser(jwtTokens['access']);
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<dynamic> login(String email, String password) async {
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

        return decodeTokenToUser(jwtTokens['access']);
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
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

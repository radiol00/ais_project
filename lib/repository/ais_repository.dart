import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AISRepository {
  Future<bool> init() async {
    final storage = new FlutterSecureStorage();
    try {
      String value = await storage.read(key: 'aisjwtaccess');
      print('walju = $value');
    } catch (e) {
      print(e);
    }
    // jwtTokens['access'] = 'asd';
    // jwtTokens['refresh'] = 'refasd';
    return false;
  }

  final String url = 'http://192.168.0.104:8000';
  final Map jwtTokens = {'access': '', 'refresh': ''};

  Future<bool> login(String email, String password) async {
    try {
      final data = {'email': email, 'password': password};
      await Future.delayed(Duration(seconds: 5));
      final response = await http.post('$url/auth/',
          headers: {'Content-Type': "application/json"},
          body: json.encode(data));

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

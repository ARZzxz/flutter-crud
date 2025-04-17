import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://devuat.blueraycargo.id";
  static const String accessToken =
      "fe17d6c84394e37f804b614871f7fdf60b71f3685df902ee2b5cf59ba5b7da887158ce2702a0f7b2a9ad44e357af6c678bf1";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/customer/auth/login");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['data']['token']);
      return true;
    } else {
      print("Login failed: ${response.body}");
      return false;
    }
  }
  Future<bool> sendRegisterCode(String email) async {
    final url = Uri.parse("$baseUrl/customer/auth/register/mini");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
      },
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }
  Future<bool> verifyRegisterCode(String email, String code) async {
    final url = Uri.parse("$baseUrl/customer/auth/register/verify-code");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
      },
      body: jsonEncode({
        "email": email,
        "code": code,
      }),
    );

    return response.statusCode == 200;
  }
  Future<bool> completeRegistration({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final url = Uri.parse("$baseUrl/customer/auth/register/mandatory");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "phone": phone,
      }),
    );

    return response.statusCode == 200;
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}

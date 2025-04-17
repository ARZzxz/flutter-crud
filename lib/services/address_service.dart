// lib/services/address_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';

class AddressService {
  static const String baseUrl = "https://devuat.blueraycargo.id";
  static const String accessToken =
      "fe17d6c84394e37f804b614871f7fdf60b71f3685df902ee2b5cf59ba5b7da887158ce2702a0f7b2a9ad44e357af6c678bf1";

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Address>> fetchAddresses({int page = 1}) async {
    final token = await _getAuthToken();
    final url = Uri.parse("$baseUrl/customer/address?page=$page");

    final response = await http.get(
      url,
      headers: {
        'AccessToken': accessToken,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => Address.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat alamat: ${response.body}");
    }
  }
  Future<bool> createAddress(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse("$baseUrl/customer/address"),
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload),
    );

    return response.statusCode == 200;
  }
  Future<List<dynamic>> fetchProvinces() async {
    final url = Uri.parse("$baseUrl/province");
    final response = await http.get(
      url,
      headers: {
        'AccessToken': accessToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Gagal memuat provinsi');
    }
  }

  Future<List<dynamic>> fetchDistricts(int provinceId) async {
    final url = Uri.parse("$baseUrl/district?province_id=$provinceId");
    final response = await http.get(
      url,
      headers: {
        'AccessToken': accessToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Gagal memuat kota');
    }
  }

  Future<List<dynamic>> fetchSubDistricts(int districtId) async {
    final url = Uri.parse("$baseUrl/sub-district?district_id=$districtId");
    final response = await http.get(
      url,
      headers: {
        'AccessToken': accessToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Gagal memuat kecamatan');
    }
  }
  Future<bool> updateAddress(int id, Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse("$baseUrl/customer/address/$id"),
      headers: {
        'Content-Type': 'application/json',
        'AccessToken': accessToken,
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteAddress(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse("$baseUrl/customer/address/$id"),
      headers: {
        'AccessToken': accessToken,
        'Authorization': 'Bearer $authToken',
      },
    );

    return response.statusCode == 200;
  }
  Future<bool> setDefaultAddress(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse("$baseUrl/customer/address/set-default/$id"),
      headers: {
        'AccessToken': accessToken,
        'Authorization': 'Bearer $authToken',
      },
    );

    return response.statusCode == 200;
  }

}

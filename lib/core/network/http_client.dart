import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  static const String baseUrl = "https://reqres.in/api/";
  static const String apiKey = "reqres-free-v1";
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-api-key': apiKey,
  };

  static Future<http.Response> get(String endpoint) async {
    print('GET Request: $baseUrl$endpoint');
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    print('GET Response: ${response.statusCode} $baseUrl$endpoint');
    return response;
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    print('POST Request: $baseUrl$endpoint');
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    print('POST Response: ${response.statusCode} $baseUrl$endpoint');
    return response;
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    print('PUT Request: $baseUrl$endpoint');
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    print('PUT Response: ${response.statusCode} $baseUrl$endpoint');
    return response;
  }

  static Future<http.Response> delete(String endpoint) async {
    print('DELETE Request: $baseUrl$endpoint');
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    print('DELETE Response: ${response.statusCode} $baseUrl$endpoint');
    return response;
  }
}

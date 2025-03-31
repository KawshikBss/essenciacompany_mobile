import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getProducts({String? token}) async {
  if (token == null) return {'success': false, 'message': 'Login again'};
  final response = await http.get(
    Uri.parse('https://events.essenciacompany.com/api/app/extras/all'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body);
      return {'success': true, 'data': data['data']};
    } catch (error) {
      print(error.toString());
    }
  }
  return {'success': false, 'message': 'Unexpected error'};
}

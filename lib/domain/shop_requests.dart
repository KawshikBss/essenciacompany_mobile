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

Future<Map<String, dynamic>> getOrders({String? token}) async {
  if (token == null) return {'success': false, 'message': 'Login again'};
  final response = await http.get(
    Uri.parse('https://events.essenciacompany.com/api/app/orders'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body);
      return {'success': true, 'data': data};
    } catch (error) {
      print(error.toString());
    }
  }
  return {'success': false, 'message': 'Unexpected error'};
}

Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData,
    {String? token}) async {
  if (token == null) return {'success': false, 'message': 'Login again'};
  final response = await http.post(
      Uri.parse('https://events.essenciacompany.com/api/app/order/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(orderData));
  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body);
      return {'success': true, 'data': data['order']};
    } catch (error) {
      print(error.toString());
    }
  }
  return {'success': false, 'message': 'Unexpected error'};
}

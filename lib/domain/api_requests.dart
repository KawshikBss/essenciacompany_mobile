import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> checkinRequest(
    String? token, String? ticket, String? zone) async {
  if (token == null ||
      token.isEmpty ||
      ticket == null ||
      ticket.isEmpty ||
      zone == null ||
      zone.isEmpty) {
    return {
      'success': false,
      'message': 'Invalid',
    };
  }
  final response = await http.post(
      Uri.parse('https://events.essenciacompany.com/api/app/checkin'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'ticket': ticket,
        'zone_id': zone,
      }));

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {
      'success': true,
      'data': data['data'],
    };
  } else {
    return {
      'success': false,
      'message': data['error'],
    };
  }
}

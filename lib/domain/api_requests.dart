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

Future<Map<String, dynamic>> checkoutRequest(
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
      Uri.parse('https://events.essenciacompany.com/api/app/checkout'),
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

Future<Map<String, dynamic>> getExtrasRequest(
    String? token, String? ticket) async {
  if (token == null || token.isEmpty || ticket == null || ticket.isEmpty) {
    return {
      'success': false,
      'message': 'Invalid',
    };
  }
  final response = await http.post(
      Uri.parse('https://events.essenciacompany.com/api/app/extras'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'ticket': ticket,
      }));

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {
      'success': true,
      'ticket': data['ticket'],
      'extras': data['extras'],
    };
  } else {
    return {
      'success': false,
      'message': data['error'],
    };
  }
}

Future<Map<String, dynamic>> withdrawExtraRequest(
    String? token, String? ticket, String? zone, int? withdraw) async {
  if (token == null ||
      token.isEmpty ||
      ticket == null ||
      ticket.isEmpty ||
      zone == null ||
      zone.isEmpty ||
      withdraw == null) {
    return {
      'success': false,
      'message': 'Invalid',
    };
  }
  final response = await http.post(
      Uri.parse('https://events.essenciacompany.com/api/app/withdraw'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'ticket': ticket,
        'zone_id': zone,
        'withdraw': withdraw
      }));

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {
      'success': true,
      'message': data['success_msg'],
    };
  } else {
    return {
      'success': false,
      // 'message': data['error'],
    };
  }
}

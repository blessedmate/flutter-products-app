import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _urlBase = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCQL1W_S4WyyxWW3p1PwUFWh4wC3tOXs9Y';

  // A return means there was an error
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url =
        Uri.https(_urlBase, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Save on shared preferences
      // decodedResp['idToken']
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }
}

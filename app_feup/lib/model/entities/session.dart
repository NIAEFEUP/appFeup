import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  /// Whether or not the user is authenticated.
  bool authenticated;
  bool persistentSession = false;
  String faculty = 'feup'; // should not be hardcoded
  String type;
  String cookies;
  String studentNumber;
  Future loginRequest;

  Session(
      {@required bool this.authenticated,
      this.studentNumber,
      this.type,
      this.cookies}) {}

  // TODO: Is this descriptive enough?
  /// Creates a new instance from an HTTP response containing a JSON document.
  static Session fromLogin(dynamic response) {
    final responseBody = json.decode(response.body);
    if (responseBody['authenticated']) {
      return Session(
          authenticated: true,
          studentNumber: responseBody['codigo'],
          type: responseBody['tipo'],
          cookies: NetworkRouter.extractCookies(response.headers));
    } else {
      return Session(authenticated: false);
    }
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uni/controller/networking/network_router.dart';

/// Manages a generic User Session.
///
/// This class stores all the information about a User Session.
class Session {
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

  //Todo Is this descriptive enough?
  /// Returns an instance of ["Session"].
  /// 
  /// If the user is not authenticated returns an instance with `authenticated`
  /// set to false.
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

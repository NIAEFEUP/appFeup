import 'package:flutter/widgets.dart';

//TODO is this descriptive enough?
/// Stores the information about a bus.
class Bus{
  String busCode;
  String destination;
  bool direction;

  Bus({@required this.busCode, this.destination='', this.direction = false}){}

  /// Converts an instance of [Bus] to map.
  Map<String, dynamic> toMap() {
    return {
      'busCode': busCode,
      'destination': destination,
      'direction': direction
    };
  }
}
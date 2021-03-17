import 'package:logger/logger.dart';

/// Manages a generic Bus Trip.
///
/// This class stores all the information about a Bus Trip.
class Trip{
  final String line;
  final String destination;
  final int timeRemaining;

  Trip({this.line, this.destination, this.timeRemaining});

  /// Converts a [Trip] instance to map.
  Map<String, dynamic> toMap() {
    return {
      'line': line,
      'destination': destination,
      'timeRemaining': timeRemaining
    };
  }

  /// Displays the trip information (the line, destination and time remaining).
  void printTrip()
  {
    Logger().i('$line ($destination) - $timeRemaining');
  }

  /// Compares the remaining time of two [Trip] instances.
  int compare(Trip other) {
    return (timeRemaining.compareTo(other.timeRemaining));
  }
}
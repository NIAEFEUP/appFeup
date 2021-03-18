import 'package:logger/logger.dart';

/// Stores information about a bus trip.
class Trip{
  final String line;
  final String destination;
  final int timeRemaining;

  Trip({this.line, this.destination, this.timeRemaining});

  /// Converts this trip to a map.
  Map<String, dynamic> toMap() {
    return {
      'line': line,
      'destination': destination,
      'timeRemaining': timeRemaining
    };
  }

  /// Prints the data in this trip to the [Logger] with an INFO level.
  void printTrip()
  {
    Logger().i('$line ($destination) - $timeRemaining');
  }

  /// Compares the remaining time of two trips.
  int compare(Trip other) {
    return (timeRemaining.compareTo(other.timeRemaining));
  }
}
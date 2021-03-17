/// Manages the bus stops data.
///
/// An object of this class stores information about the favourited bus stops.
class BusStopData{
  final Set<String> configuredBuses;
  bool favorited;

  BusStopData({this.configuredBuses, this.favorited = false});
}
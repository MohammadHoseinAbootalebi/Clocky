class TimeZoneLocation {
  String countryName;
  String cityName;
  int hours;
  int minutes;
  int seconds;
  String beforeOrAfter;

  TimeZoneLocation({
    required this.countryName,
    required this.cityName,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.beforeOrAfter,
  });

  // Make this method compatible with TimeZoneLocation class
  factory TimeZoneLocation.fromJson(Map<String, dynamic> jsonData) {
    return TimeZoneLocation(
      countryName: jsonData['Name'],
      cityName: jsonData['Hours'],
      hours: jsonData['Minutes'],
      minutes: jsonData['id'],
      seconds: jsonData['isToggle'],
      beforeOrAfter: jsonData['isToggle'],
    );
  }
}

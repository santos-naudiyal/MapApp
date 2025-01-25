class StoreModel {
  final String code;
  final String storeLocation;
  final double latitude;
  final double longitude;
  final String storeAddress;
  final double distance;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isNearestStore;

  StoreModel({
    required this.code,
    required this.storeLocation,
    required this.latitude,
    required this.longitude,
    required this.storeAddress,
    required this.distance,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isNearestStore,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      code: json['code'],
      storeLocation: json['storeLocation'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      storeAddress: json['storeAddress'],
      distance: json['distance'],
      dayOfWeek: json['dayOfWeek'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isNearestStore: json['isNearestStore'] == 1,
    );
  }
}

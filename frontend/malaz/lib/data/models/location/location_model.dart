import '../../../domain/entities/location/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.lat, required super.lng, required super.address});

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
    );
  }
}
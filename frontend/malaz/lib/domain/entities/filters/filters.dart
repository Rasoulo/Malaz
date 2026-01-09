class Filter {
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final String? type;

  final int? minRooms;
  final int? maxRooms;
  final int? minBedrooms;
  final int? maxBedrooms;
  final int? minBathrooms;
  final int? maxBathrooms;

  final double? lat;
  final double? lng;
  final double? radiusInKm;

  Filter({
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.type,
    this.minRooms,
    this.maxRooms,
    this.minBedrooms,
    this.maxBedrooms,
    this.minBathrooms,
    this.maxBathrooms,
    this.lat,
    this.lng,
    this.radiusInKm,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (minArea != null) map['min_area'] = minArea;
    if (maxArea != null) map['max_area'] = maxArea;
    if (type != null) map['type'] = type;

    if (minRooms != null) map['rooms_min'] = minRooms;
    if (maxRooms != null) map['rooms_max'] = maxRooms;

    if (minBedrooms != null) map['bedrooms_min'] = minBedrooms;
    if (maxBedrooms != null) map['bedrooms_max'] = maxBedrooms;

    if (minBathrooms != null) map['baths_min'] = minBathrooms;
    if (maxBathrooms != null) map['baths_max'] = maxBathrooms;

    if (lat != null && lng != null) {
      map['lat'] = lat;
      map['lng'] = lng;
      map['radius'] = radiusInKm ?? 10;
    }
    return map;
  }
}
import '../../domain/entities/apartment.dart';

class ApartmentModel extends Apartment {
  ApartmentModel({
    required super.id,
    required super.ownerId,
    required super.status,
    required super.title,
    required super.price,
    required super.city,
    required super.governorate,
    required super.address,
    required super.description,
    required super.type,
    required super.rooms,
    required super.bathrooms,
    required super.bedrooms,
    required super.area,
    required super.rating,
    required super.numberOfReviews,
    required super.mainImageUrl,
    super.isFav,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'] as int,
      ownerId: json['owner_id'] as int? ?? 0,
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',

      rooms: (json['number_of_rooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['number_of_baths'] as num?)?.toInt() ?? 0,
      bedrooms: (json['number_of_bedrooms'] as num?)?.toInt() ?? 0,

      area: (json['area'] as num?)?.toInt() ?? 0,
      rating: json['rating'] as num? ?? 0,
      numberOfReviews: (json['number_of_reviews'] as num?)?.toInt() ?? 0,

      mainImageUrl: json['main_image_url'] ?? '',

      isFav: json['is_favorite'] ?? false,
    );
  }
}
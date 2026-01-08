import 'package:malaz/data/models/user_model.dart';
import 'package:malaz/domain/entities/user_entity.dart';

import '../../domain/entities/apartment.dart';

class ApartmentModel extends Apartment {
  ApartmentModel({
    required super.id,
    required super.ownerId,
    required super.owner,
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
      owner: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : UserEntity(id: 0, first_name: '', last_name: '', phone: '', role: '', date_of_birth: '', profile_image_url: '', identity_card_image_url: '', phone_verified_at: '', created_at: '', updated_at: ''),      status: json['status'] ?? '',
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
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'owner_id': ownerId,
      'status': status,
      'title': title,
      'price': price,
      'city': city,
      'governorate': governorate,
      'address': address,
      'description': description,
      'type': type,
      'number_of_rooms': rooms,
      'number_of_baths': bathrooms,
      'number_of_bedrooms': bedrooms,
      'area': area,
      'rating': rating,
      'number_of_reviews': numberOfReviews,
      'main_image_url': mainImageUrl,
      'is_favorite': isFav
    };
  }
}
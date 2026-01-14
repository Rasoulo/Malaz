import 'package:malaz/domain/entities/user/user_entity.dart';

class Apartment {
  final int id;
  final int ownerId;
  final UserEntity owner;
  final String status;
  final String title;
  final int price;
  final String city;
  final String governorate;
  final String address;
  final String description;
  final String type;
  final int rooms;
  final int bathrooms;
  final int bedrooms;
  final int area;
  final num rating;
  final int numberOfReviews;
  final String mainImageUrl;
  final List<String> images;
  final bool isFav;
  final double? latitude;
  final double? longitude;

  Apartment({
    required this.id,
    required this.ownerId,
    required this.owner,
    required this.status,
    required this.title,
    required this.price,
    required this.city,
    required this.governorate,
    required this.address,
    required this.description,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.bedrooms,
    required this.area,
    required this.rating,
    required this.numberOfReviews,
    required this.mainImageUrl,
    required this.images,
    this.isFav = false,
    this.latitude,
    this.longitude
  });

  @override
  List<Object?> get props => [id,ownerId,status,title,price,city,governorate,address,description,type,rooms,bathrooms,bedrooms,area,rating,numberOfReviews,mainImageUrl,isFav, images];
}
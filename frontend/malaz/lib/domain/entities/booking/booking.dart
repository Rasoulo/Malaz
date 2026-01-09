import 'package:equatable/equatable.dart';
import 'package:malaz/domain/entities/user/user_entity.dart';
import '../apartment/apartment.dart';

class Booking extends Equatable {
  final int? id;
  final int? propertyId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final num? price;
  final int? userId;
  final UserEntity? user;
  final String? status;
  final String? totalPrice;
  final Apartment? apartment;

  const Booking({
    this.id,
    this.propertyId,
    this.checkIn,
    this.checkOut,
    this.price,
    this.userId,
    this.user,
    this.status,
    this.totalPrice,
    this.apartment,
  });

  @override
  List<Object?> get props => [
    id,
    propertyId,
    checkIn,
    checkOut,
    price,
    userId,
    user,
    status,
    totalPrice,
    apartment,
  ];
}
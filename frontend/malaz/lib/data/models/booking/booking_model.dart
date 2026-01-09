import 'package:malaz/data/models/apartment/apartment_model.dart';
import 'package:malaz/data/models/user/user_model.dart';
import 'package:malaz/domain/entities/booking/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    super.id,
    required super.propertyId,
    required super.checkIn,
    required super.checkOut,
    required super.price,
    super.userId,
    super.user,
    super.status,
    super.totalPrice,
    super.apartment,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    try {
      return BookingModel(
        id: json['id'],
        propertyId: json['property_id'],
        checkIn: DateTime.parse(json['check_in']),
        checkOut: DateTime.parse(json['check_out']),
        price: json['property'] != null ? (json['property']['price'] as num).toInt() : 0,
        userId: json['user_id'],
        status: json['status'],
        totalPrice: json['total_price']?.toString(),
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        apartment: json['property'] != null ? ApartmentModel.fromJson(json['property']) : null,
      );
    } catch (e, stackTrace) {
      // هذا الجزء سيخبرنا بالضبط أين المشكلة
      print("❌ Error parsing BookingModel: $e");
      print("❌ StackTrace: $stackTrace");
      rethrow;
    }
  }
}
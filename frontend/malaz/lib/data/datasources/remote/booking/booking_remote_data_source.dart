import '../../../../core/network/network_service.dart';
import '../../../../domain/entities/booking.dart';
import '../../../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> makeBooking(Booking booking);
  Future<List<BookingModel>> getBookedDates(int propertyId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final NetworkService networkService;

  BookingRemoteDataSourceImpl({required this.networkService});

  @override
  Future<void> makeBooking(Booking booking) async {
    await networkService.post(
      '/bookings/store',
      queryParameters: {
        'property_id': booking.propertyId,
        'check_in': booking.checkIn,
        'check_out': booking.checkOut,
        'total_price': booking.price
      },
    );
  }

  @override
  Future<List<BookingModel>> getBookedDates(int propertyId) async {
    final response = await networkService.get(
      '/properties/all_booked/$propertyId',
    );

    final List data = response.data['data'];
    return data.map((e) => BookingModel.fromJson(e)).toList();
  }
}
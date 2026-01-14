import '../../../../core/network/network_service.dart';
import '../../../../domain/entities/booking/booking.dart';
import '../../../../domain/entities/booking/booking_list.dart';
import '../../../models/booking/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> makeBooking(Booking booking);
  Future<List<BookingModel>> getBookedDates(int propertyId);
  Future<BookingList> fetchAllBookings(int userId);
  Future<void> UpdateStatus(int propertyId,String status);
  Future<BookingList> fetchMyBookings(int userId);
  Future<void> updateBookingDate(int bookingId, String checkIn, String checkOut);


}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final NetworkService networkService;

  BookingRemoteDataSourceImpl({required this.networkService});

  @override
  Future<void> makeBooking(Booking booking) async {
    final response = await networkService.post(
      '/bookings/store',
      queryParameters: {
        'property_id': booking.propertyId,
        'check_in': booking.checkIn.toString().split(' ')[0],
        'check_out': booking.checkOut.toString().split(' ')[0],
        'total_price': booking.totalPrice
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

  @override
  Future<BookingList> fetchAllBookings(int userId) async {
    final response = await networkService.get(
      "/bookings/owner/$userId",
    );

    List<BookingModel> bookings = [];
    if (response.data != null) {
      print('Server Response Data: ${response.data}');
      final List? rawData = response.data['bookings'];

      if (rawData != null) {
        bookings = rawData.map((e) => BookingModel.fromJson(e)).toList();
      }
    } else {
      print('No data found in response');
    }

    return BookingList(booking: bookings);
  }

  @override
  Future<void> UpdateStatus(int propertyId, String status) async {
    final response = await networkService.patch(
        '/bookings/update/$propertyId',
        queryParameters: {
          'status': status
        }
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data['message'] ?? 'Failed to update status');
    }
    print('Update Status Success: ${response.data}');
  }

  Future<BookingList> fetchMyBookings(int userId) async {
    final response = await networkService.get(
      "/bookings/user/$userId",
    );
    List<BookingModel> bookings = [];

    if (response.data != null) {
      print('Server Response Data: ${response.data}');

      dynamic rawData = response.data;
      List<dynamic> listData = [];

      if (rawData is List) {
        listData = rawData;
      } else if (rawData is Map) {
        listData = rawData.values.toList();
      }

      bookings = listData.map((e) => BookingModel.fromJson(e)).toList();

    } else {
      print('No data found in response');
    }

    return BookingList(booking: bookings);
  }

  Future<void> updateBookingDate(int bookingId, String checkIn, String checkOut) async {
    final response = await networkService.patch(
      '/bookings/update/$bookingId',
      queryParameters: {
        'check_in': checkIn,
        'check_out': checkOut,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data['message'] ?? 'Failed to update booking date');
    }
  }
}
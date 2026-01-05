class BookingModel {
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double price;

  BookingModel({required this.propertyId,required this.checkIn, required this.checkOut, required this.price});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      propertyId: json['property_id'].toString(),
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      price: json['total_price'].toDouble(),
    );
  }
}
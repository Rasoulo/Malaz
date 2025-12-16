import 'apartment.dart';

class ApartmentsList {
  final List<Apartment> apartments;
  final String? nextCursor;
  final String? prevCursor;

  ApartmentsList({
    required this.apartments,
    this.nextCursor,
    this.prevCursor,
  });
}
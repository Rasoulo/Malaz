
import 'package:malaz/domain/entities/apartment.dart';

abstract class ApartmentRepository {
  Future<List<Apartment>> getApartments();
}

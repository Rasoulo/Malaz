
import '../../../domain/entities/apartment.dart';

// This is the contract for our data source
abstract class ApartmentRemoteDataSource {
  Future<List<Apartment>> getApartments();
}

// This is the implementation of the contract
class ApartmentRemoteDataSourceImpl implements ApartmentRemoteDataSource {
  // In a real app, you would inject an HTTP client here (e.g., Dio, http)
  // final http.Client client;
  // ApartmentRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Apartment>> getApartments() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an API call here
    // For now, we return the mock data.
    // Note: We are returning the ENTITY directly because this is a simple app.
    // In a larger app, you would return a MODEL and map it to an entity in the repository.
    return mockApartments;
  }
}


// Mock data - In a real app, this would be on a server
final List<Apartment> mockApartments = [
  Apartment(
    id: '1',
    title: 'Modern Downtown Apartment',
    location: 'Downtown, City Center',
    price: 1200,
    imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&fit=crop',
    bedrooms: 2,
    bathrooms: 2,
    areaSqft: 1200,
  ),
  Apartment(
    id: '2',
    title: 'Luxury Penthouse Suite',
    location: 'Uptown, Premium District',
    price: 2500,
    imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&fit=crop',
    bedrooms: 3,
    bathrooms: 3,
    areaSqft: 2000,
  ),
    Apartment(
    id: '3',
    title: 'Cozy Suburban House',
    location: 'Green Valley, Suburbs',
    price: 1800,
    imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&fit=crop',
    bedrooms: 4,
    bathrooms: 3,
    areaSqft: 2500,
  ),
];

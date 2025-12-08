import '../../../domain/entities/apartment.dart';

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
];
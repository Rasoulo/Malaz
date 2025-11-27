class Apartment {
  final String id;
  final String title;
  final String location;
  final double price;
  final String imageUrl;
  final int bedrooms;
  final int bathrooms;
  final int areaSqft;
  final bool isFavorite;

  Apartment({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    this.isFavorite = false,
  });
}
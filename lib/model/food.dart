import 'review.dart';

class Food {
  // Information
  int id;
  String name;
  double price;
  Map<String, String> allergies;
  List<String> image;
  // Statistics
  int likes;
  int saves;
  List<Review> reviews;


  Food ({
    required this.id,
    required this.name,
    required this.price,
    required this.allergies,
    required this.image,
    required this.likes,
    required this.saves,
    required this.reviews,
  });
}
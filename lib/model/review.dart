// Review class used to represent user reviews of restaurants.
class Review {
  int id;
  double rating;
  String review;

  Review ({
    required this.id,
    required this.rating,
    required this.review,
  });
}
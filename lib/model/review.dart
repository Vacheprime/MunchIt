import 'package:munchit/services/utils/utils.dart';

/// Review class is used to represent user reviews of restaurants.
class Review {
  String? _docId;
  late double _rating;
  late String _reviewContent;

  Review(double rating, String reviewContent) {
    setRating(rating);
    setReviewContent(reviewContent);
  }

  factory Review.fromFirebase(String docId, Map<String, dynamic> data) {
    Review review = new Review(data["rating"], data["reviewContent"]);
    review.setDocId(docId);
    return review;
  }

  Map<String, dynamic> toMap() {
    return {
      "rating": _rating,
      "reviewContent": _reviewContent
    };
  }

  String? getDocId() {
    return _docId;
  }

  void setDocId(String docId) {
    _docId = docId;
  }

  double getRating() {
    return _rating;
  }

  void setRating(double rating) {
    if (!validateRating(rating)) throw ArgumentError("The rating is invalid!");
    _rating = rating;
  }

  String getReviewContent() {
    return _reviewContent;
  }

  void setReviewContent(String reviewContent) {
    if (!validateReviewContent(reviewContent)) throw ArgumentError("The review content is invalid");
    _reviewContent = reviewContent;
  }

  static bool validateRating(double rating) {
    return rating <= 5 && rating >= 0;
  }

  static bool validateReviewContent(String reviewContent) {
    if (Utils.hasInvalidSpaces(reviewContent)) return false;
    RegExp validContentRegex = RegExp("^[\\s\\p{L}0-9()\\[\\]{}'.\"]+\$", unicode: true);
    return validContentRegex.hasMatch(reviewContent);
  }
}
import 'package:flutter/material.dart';
import 'package:munchit/model/restaurant.dart';
import '../model/user.dart';
import '../model/food.dart';

class CreateReview extends StatefulWidget {
  final User user;
  final Restaurant? restaurant;
  final Food? food;

  const CreateReview.forRestaurant({
    required this.user,
    required Restaurant restaurant,
    Key? key,
  })  : restaurant = restaurant,
        food = null,
        super(key: key);

  const CreateReview.forFood({
    required this.user,
    required Food food,
    Key? key,
  })  : food = food,
        restaurant = null,
        super(key: key);


  @override
  State<CreateReview> createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {

  final TextEditingController _reviewController = TextEditingController();
  String? _selectedRating;

  @override
  Widget build(BuildContext context) {
    final isFood = widget.food != null;

    final title = isFood ? widget.food!.getName() : widget.restaurant!
        .getName();
    final subtitle = isFood ? widget.food!.getName() /*NEED THE RESTAURANT NAME OF THE FOOD*/ : widget.restaurant!
        .getAddress();
    final imageUrl = isFood ? widget.food!.getImageUrl() : widget.restaurant!
        .getImageUrl();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(title, style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(subtitle),
                ),
              ),
              if (imageUrl != null)
                Image.network(imageUrl, height: 80, width: 80, fit: BoxFit.cover),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [ //generate ratings
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star_border),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            hint: const Text("Select"),
            value: _selectedRating,
            onChanged: (value) => setState(() => _selectedRating = value),
            items: ['1', '2', '3', '4', '5']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Review",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: _addReview,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _addReview() {
    final reviewText = _reviewController.text;
    final rating = _selectedRating;

    if (reviewText.isEmpty || rating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and a review.")),
      );
      return;
    }

    if (widget.food != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added review for ${widget.food!.getName()}")));
    } else if (widget.restaurant != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully added review for ${widget.restaurant!.getName()}")));
    }
  }

}



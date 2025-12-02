import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String summary;
  final int rating;
  final String? quotes;
  final String? imagePath; // local file path
  final String? imageUrl;  // network image URL (optional)
  final Timestamp? createdAt;

  Book({
    required this.title,
    required this.summary,
    required this.rating,
    this.quotes,
    this.imagePath,
    this.imageUrl,
    this.createdAt,
  });
}

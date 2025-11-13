import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book_model.dart';

class BookService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';

  static Future<List<Book>> fetchBooks(String query) async {
    final response = await http.get(Uri.parse('$baseUrl$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}

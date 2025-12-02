import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';

  static Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final url = Uri.parse('$baseUrl$query');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch books');
    }

    final data = json.decode(response.body);
    final items = data['items'] ?? [];

    return items.map<Map<String, dynamic>>((item) {
      final info = item['volumeInfo'] ?? {};
      final imageLinks = info['imageLinks'] ?? {};

      return {
        'id': item['id'],
        'title': info['title'] ?? 'Untitled',
        'summary': info['description'] ?? 'No description available.',
        'rating': 0, // User can rate later
        'imageNetwork': imageLinks['thumbnail'],
      };
    }).toList();
  }
}

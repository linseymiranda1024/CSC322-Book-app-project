import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

typedef OnBookSelected = void Function(Book book);

class SearchScreen extends StatefulWidget {
  final OnBookSelected? onBookSelected;

  const SearchScreen({super.key, this.onBookSelected});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    try {
      final url = Uri.parse(
          'https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List<dynamic>;

        final results = docs.take(20).map((doc) {
          // Try to get first_sentence
          String summary = '';
          if (doc['first_sentence'] != null) {
            if (doc['first_sentence'] is String) {
              summary = doc['first_sentence'];
            } else if (doc['first_sentence'] is Map &&
                doc['first_sentence']['value'] != null) {
              summary = doc['first_sentence']['value'];
            }
          }

          // Fallbacks: subtitle, author_name, publish_year
          if (summary.isEmpty) {
            if (doc['subtitle'] != null) {
              summary = doc['subtitle'];
            } else if (doc['author_name'] != null) {
              summary = 'By ${doc['author_name'].join(", ")}';
            } else {
              summary = 'No description available';
            }
          }

          return Book(
            title: doc['title'] ?? 'No Title',
            summary: summary,
            rating: 3,
            quotes: '',
            imageUrl: doc['cover_i'] != null
                ? 'https://covers.openlibrary.org/b/id/${doc['cover_i']}-M.jpg'
                : null,
          );
        }).toList();

        setState(() {
          _searchResults = results;
        });
      } else {
        print('Error fetching books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching books: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddBookDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book.title),
          content: Text(
            book.summary.isNotEmpty ? book.summary : 'No description available',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (widget.onBookSelected != null) {
                  widget.onBookSelected!(book);
                }
              },
              child: const Text('Add to My Books'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search books by title',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _searchBooks(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searchBooks,
                child: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final book = _searchResults[index];
                    return ListTile(
                      leading: book.imageUrl != null
                          ? Image.network(
                              book.imageUrl!,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.book),
                      title: Text(book.title),
                      subtitle: Text(
                        book.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _showAddBookDialog(book),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

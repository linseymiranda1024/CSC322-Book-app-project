import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';

class YourBooksScreen extends StatelessWidget {
  final List<Book> books;
  final VoidCallback onFabPressed;

  const YourBooksScreen({
    super.key,
    required this.books,
    required this.onFabPressed,
  });

  Widget _buildBookList() {
    if (books.isEmpty) {
      return const Center(
        child: Text(
          'No books added yet.\nTap the + icon to add your first book!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        Widget imageWidget = const Icon(Icons.book, size: 40);
        if (book.imagePath != null) {
          imageWidget = Image.file(File(book.imagePath!), width: 50, fit: BoxFit.cover);
        } else if (book.imageUrl != null) {
          imageWidget = Image.network(book.imageUrl!, width: 50, fit: BoxFit.cover);
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
            title: Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  book.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < book.rating ? Icons.star : Icons.star_border,
                      color: const Color.fromARGB(255, 176, 143, 43),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBookList(),
      floatingActionButton: FloatingActionButton(
        onPressed: onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}

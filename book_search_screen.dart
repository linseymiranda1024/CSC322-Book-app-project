import 'package:flutter/material.dart';
import 'book_model.dart';
import 'book_service.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Book> _books = [];
  bool _loading = false;
  List<Book> _library = []; // temporary "My Library"

  Future<void> _searchBooks() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _loading = true);

    try {
      final results = await BookService.fetchBooks(query);
      setState(() => _books = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching books: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _addToLibrary(Book book) {
    if (_library.any((b) => b.id == book.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${book.title} is already in your library!')),
      );
      return;
    }

    setState(() {
      _library.add(book);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${book.title} added to your library!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyLibraryScreen(library: _library)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchBooks(),
              decoration: InputDecoration(
                hintText: 'Search for a book...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: book.thumbnail.isNotEmpty
                            ? Image.network(book.thumbnail, width: 50, fit: BoxFit.cover)
                            : const Icon(Icons.book, size: 40),
                        title: Text(book.title),
                        subtitle: Text(book.authors.join(", ")),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addToLibrary(book),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MyLibraryScreen extends StatelessWidget {
  final List<Book> library;

  const MyLibraryScreen({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: library.isEmpty
          ? const Center(child: Text('Your library is empty!'))
          : ListView.builder(
              itemCount: library.length,
              itemBuilder: (context, index) {
                final book = library[index];
                return ListTile(
                  leading: book.thumbnail.isNotEmpty
                      ? Image.network(book.thumbnail, width: 50)
                      : const Icon(Icons.book, size: 40),
                  title: Text(book.title),
                  subtitle: Text(book.authors.join(", ")),
                );
              },
            ),
    );
  }
}

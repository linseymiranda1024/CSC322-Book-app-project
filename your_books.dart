import 'dart:io';
import 'package:flutter/material.dart';
import 'book_entry_screen.dart';
import 'search_screen.dart';
import 'quotes_screen.dart';
import 'profile_screen.dart';

class YourBooksScreen extends StatefulWidget {
  const YourBooksScreen({super.key});

  @override
  State<YourBooksScreen> createState() => _YourBooksScreenState();
}

class _YourBooksScreenState extends State<YourBooksScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _books = [];

  // Handle bottom nav taps
  void _onItemTapped(int index) async {
    if (index == 2) {
      final newBook = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(builder: (context) => const BookEntryScreen()),
      );

      if (newBook != null) {
        setState(() {
          _books.add(newBook);
          _selectedIndex = 0;
        });
      }
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: const Color.fromARGB(255, 176, 143, 43),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildBookList() {
    return _books.isEmpty
        ? const Center(
            child: Text(
              'No books added yet.\nTap the + icon below to add your own!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _books.length,
            itemBuilder: (context, index) {
              final book = _books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: book['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(book['image']),
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.book, color: Colors.brown),
                        ),
                  title: Text(
                    book['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        book['summary'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _buildRatingStars(book['rating']),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildBookList(),
      const SearchScreen(),
      const SizedBox(), 
      const QuotesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 230, 210),
      appBar: AppBar(
        title: Text(
          ['Your Books', 'Search', 'Add Book', 'Quotes', 'Profile'][_selectedIndex],
        ),
        backgroundColor: const Color.fromARGB(255, 100, 73, 31),
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 100, 73, 31),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Books'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add Book'),
          BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Quotes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

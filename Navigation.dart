import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import 'your_books.dart';
import 'book_entry_screen.dart';
import 'search_screen.dart';
import 'quotes_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Book> _books = [];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _addBook(BuildContext context) async {
    final newBook = await Navigator.push<Book?>(
      context,
      MaterialPageRoute(builder: (context) => const BookEntryScreen()),
    );

    if (newBook != null) {
      // Save to Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .add({
          'title': newBook.title,
          'summary': newBook.summary,
          'rating': newBook.rating,
          'quotes': newBook.quotes,
          'imagePath': newBook.imagePath,
          'createdAt': newBook.createdAt,
        });
      }

      setState(() {
        _books.add(newBook);
        _selectedIndex = 0; // go back to "Your Books" tab
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      YourBooksScreen(
        books: _books,
        onFabPressed: () => _addBook(context),
      ),
      SearchScreen(
        onBookSelected: (book) {
          setState(() {
            _books.add(book);
            _selectedIndex = 0;
          });
        },
      ),
      const QuotesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 230, 210),
      appBar: AppBar(
        title: Text(['My Books', 'Search', 'Quotes', 'Profile'][_selectedIndex]),
        backgroundColor: const Color.fromARGB(255, 100, 73, 31),
        foregroundColor: const Color.fromARGB(255, 240, 230, 210),
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
          BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Quotes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

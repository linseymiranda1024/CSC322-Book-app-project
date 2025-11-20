import 'package:flutter/material.dart';
import 'your_books.dart';
import 'search_screen.dart';
import 'book_entry_screen.dart';
import 'quotes_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _books = [];

  void _onItemTapped(int index) async {
    if (index == 2) {
      final newBook = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(builder: (context) => const BookEntryScreen()),
      );

      if (newBook != null) {
        setState(() {
          _books.add(newBook);
        });
      }
      return; 
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      YourBooksScreen(books: _books),  
      const SearchScreen(),           
      const SizedBox(),               
      QuotesScreen(books: _books),    
      const ProfileScreen(),          
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 230, 210),
      appBar: AppBar(
        title: Text(
          ['Your Books', 'Search', 'Add Book', 'Quotes', 'Profile'][_selectedIndex],
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add Book'),
          BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Quotes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

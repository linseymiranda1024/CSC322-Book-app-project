import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookEntryScreen extends StatefulWidget {
  const BookEntryScreen({super.key});

  @override
  State<BookEntryScreen> createState() => _BookEntryScreenState();
}

class _BookEntryScreenState extends State<BookEntryScreen> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _quotesController = TextEditingController();

  int _rating = 3;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  void _setRating(int stars) {
    setState(() {
      _rating = stars;
    });
  }

  Future<void> _saveBook() async {
    final title = _titleController.text.trim();
    final summary = _summaryController.text.trim();

    if (title.isEmpty || summary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('USER IS NULL');
      return;
    }

    final newBook = Book(
      title: title,
      summary: summary,
      rating: _rating,
      quotes: _quotesController.text.trim(),
      imagePath: _selectedImage?.path,
      createdAt: Timestamp.now(),
    );

    try {
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

      Navigator.pop(context, newBook); // Return the Book object
    } catch (e) {
      print('Error saving book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save book')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 230, 210),
      appBar: AppBar(
        title: const Text('Add Book'),
        backgroundColor: const Color.fromARGB(255, 100, 73, 31),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Book Title'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: 155,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(86, 132, 113, 84),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.brown),
                ),
                child: _selectedImage == null
                    ? const Center(child: Text('Insert book cover'))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _summaryController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Summary'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Rating:'),
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    icon: Icon(
                      i <= _rating ? Icons.star : Icons.star_border,
                      color: const Color.fromARGB(255, 176, 143, 43),
                    ),
                    onPressed: () => _setRating(i),
                  ),
              ],
            ),
            TextField(
              controller: _quotesController,
              decoration: const InputDecoration(labelText: 'Favorite Quotes'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveBook,
              icon: const Icon(Icons.save),
              label: const Text('Save Book'),
            ),
          ],
        ),
      ),
    );
  }
}

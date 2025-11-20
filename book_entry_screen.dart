import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
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

    final newBook = {
      'title': title,
      'summary': summary,
      'rating': _rating,
      'image': null, 
      'quotes': _quotesController.text.trim(),
    };

    final url = Uri.parse(
      'https://book-app-projec-default-rtdb.firebaseio.com/books.json',
    );

    await http.post(
      url,
      body: json.encode(newBook),
    );

    Navigator.pop(context, newBook);
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Book Title'),
            ),
            const SizedBox(height: 20),

  
            Center(
              child: GestureDetector(
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
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 155,
                            height: 200,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _summaryController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Summary',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'Rating:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => _setRating(i),
                    icon: Icon(
                      i <= _rating ? Icons.star : Icons.star_border,
                      color: const Color.fromARGB(255, 176, 143, 43),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _quotesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Favorite Quotes',
                border: OutlineInputBorder(),
              ),
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

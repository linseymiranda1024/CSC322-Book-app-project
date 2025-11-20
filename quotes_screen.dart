import 'package:flutter/material.dart';

class QuotesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const QuotesScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final quotesList = books
        .where((b) => b['quotes'] != null && b['quotes'].toString().trim().isNotEmpty)
        .map((b) => {'title': b['title'], 'quote': b['quotes']})
        .toList();

    return quotesList.isEmpty
        ? const Center(
            child: Text(
              "No quotes yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: quotesList.length,
            itemBuilder: (context, index) {
              final q = quotesList[index];
              return Card(
                color: const Color.fromARGB(158, 155, 133, 102),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('"${q['quote']}"'),
                  subtitle: Text('- ${q['title']}'),
                ),
              );
            },
          );
  }
}

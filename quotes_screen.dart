import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          "Not logged in.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Still loading?
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No quotes yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // Build list of quotes from Firestore docs
        final docs = snapshot.data!.docs;

        final quotesList = docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((b) =>
                b['quotes'] != null &&
                b['quotes'].toString().trim().isNotEmpty)
            .map((b) => {
                  'title': b['title'] ?? '',
                  'quote': b['quotes'] ?? '',
                })
            .toList();

        if (quotesList.isEmpty) {
          return const Center(
            child: Text(
              "No quotes yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
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
      },
    );
  }
}

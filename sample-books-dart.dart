class Book {
  final String title;
  final String author;
  final int wordCount;
  final String genre;
  final bool isPartOfSeries;

  Book({
    required this.title,
    required this.author,
    required this.wordCount,
    required this.genre,
    required this.isPartOfSeries,
  });

  // Optional: Add a method to convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'wordCount': wordCount,
      'genre': genre,
      'isPartOfSeries': isPartOfSeries ? 1 : 0,
    };
  }

  // Optional: Add a factory constructor to create from Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      author: map['author'],
      wordCount: map['wordCount'],
      genre: map['genre'],
      isPartOfSeries: map['isPartOfSeries'] == 1,
    );
  }
}

// Sample books data
final List<Book> sampleBooks = [
  Book(
    title: 'The Midnight Library',
    author: 'Matt Haig',
    wordCount: 77000,
    genre: 'Fiction',
    isPartOfSeries: false,
  ),
  Book(
    title: 'Harry Potter and the Philosopher\'s Stone',
    author: 'J.K. Rowling',
    wordCount: 77325,
    genre: 'Fantasy',
    isPartOfSeries: true,
  ),
  Book(
    title: 'The Hobbit',
    author: 'J.R.R. Tolkien',
    wordCount: 95356,
    genre: 'Fantasy',
    isPartOfSeries: true,
  ),
  Book(
    title: 'To Kill a Mockingbird',
    author: 'Harper Lee',
    wordCount: 100388,
    genre: 'Classic Fiction',
    isPartOfSeries: false,
  ),
  Book(
    title: '1984',
    author: 'George Orwell',
    wordCount: 88942,
    genre: 'Dystopian',
    isPartOfSeries: false,
  ),
  Book(
    title: 'The Hunger Games',
    author: 'Suzanne Collins',
    wordCount: 101564,
    genre: 'Young Adult',
    isPartOfSeries: true,
  ),
  Book(
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    wordCount: 122189,
    genre: 'Romance',
    isPartOfSeries: false,
  ),
  Book(
    title: 'The Fellowship of the Ring',
    author: 'J.R.R. Tolkien',
    wordCount: 187790,
    genre: 'Fantasy',
    isPartOfSeries: true,
  ),
  Book(
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    wordCount: 47094,
    genre: 'Classic Fiction',
    isPartOfSeries: false,
  ),
  Book(
    title: 'Dune',
    author: 'Frank Herbert',
    wordCount: 187240,
    genre: 'Science Fiction',
    isPartOfSeries: true,
  ),
  Book(
    title: 'The Catcher in the Rye',
    author: 'J.D. Salinger',
    wordCount: 73404,
    genre: 'Classic Fiction',
    isPartOfSeries: false,
  ),
  Book(
    title: 'A Game of Thrones',
    author: 'George R.R. Martin',
    wordCount: 298000,
    genre: 'Fantasy',
    isPartOfSeries: true,
  ),
  Book(
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    wordCount: 47119,
    genre: 'Fiction',
    isPartOfSeries: false,
  ),
  Book(
    title: 'Murder on the Orient Express',
    author: 'Agatha Christie',
    wordCount: 62062,
    genre: 'Mystery',
    isPartOfSeries: false,
  ),
  Book(
    title: 'The Silent Patient',
    author: 'Alex Michaelides',
    wordCount: 89999,
    genre: 'Thriller',
    isPartOfSeries: false,
  ),
];
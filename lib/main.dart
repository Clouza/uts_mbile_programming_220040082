import 'package:flutter/material.dart';

void main() {
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookHomePage(),
    );
  }
}

class Book {
  final String title;
  final String artist;
  final String album;
  final int releaseYear;
  final String albumCover;

  Book({
    required this.title,
    required this.artist,
    required this.album,
    required this.releaseYear,
    required this.albumCover,
  });
}

class BookHomePage extends StatefulWidget {
  const BookHomePage({super.key});

  @override
  _BookHomePageState createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  final List<Book> _books = [
    Book(
      title: "Laskar Pelangi",
      artist: "Andre Hirata",
      album: "Novel",
      releaseYear: 2005,
      albumCover:
          "https://upload.wikimedia.org/wikipedia/id/thumb/8/8e/Laskar_pelangi_sampul.jpg/220px-Laskar_pelangi_sampul.jpg",
    ),
    Book(
      title: "Negeri 5 Menara",
      artist: " Ahmad Fuadi",
      album: "Novel",
      releaseYear: 2009,
      albumCover:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRnu1Z6TlrpkKIFikSSY2afGmbK0xgcjFhow&s",
    ),
  ];

  void _addBook(Book book) {
    setState(() {
      _books.add(book);
    });
  }

  void _updateBook(int index, Book updatedBook) {
    setState(() {
      _books[index] = updatedBook;
    });
  }

  void _deleteBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  void _showBookForm([int? index]) {
    final isEditing = index != null;
    final book = isEditing ? _books[index!] : null;

    final titleController = TextEditingController(text: book?.title);
    final artistController = TextEditingController(text: book?.artist);
    final albumController = TextEditingController(text: book?.album);
    final yearController =
        TextEditingController(text: book?.releaseYear.toString());
    final coverController = TextEditingController(text: book?.albumCover);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Book" : "Add Book"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(labelText: "Artis"),
              ),
              TextField(
                controller: albumController,
                decoration: const InputDecoration(labelText: "Album"),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: "Tahun Rilis"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: coverController,
                decoration:
                    const InputDecoration(labelText: "URL Gambar Album"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newBook = Book(
                title: titleController.text,
                artist: artistController.text,
                album: albumController.text,
                releaseYear: int.tryParse(yearController.text) ?? 0,
                albumCover: coverController.text,
              );

              if (isEditing) {
                _updateBook(index!, newBook);
              } else {
                _addBook(newBook);
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Manager"),
      ),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return Card(
            child: ListTile(
              leading: Image.network(book.albumCover, width: 50, height: 50),
              title: Text(book.title),
              subtitle:
                  Text("${book.artist} - ${book.album} (${book.releaseYear})"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showBookForm(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteBook(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

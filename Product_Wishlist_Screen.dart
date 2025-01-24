import 'package:flutter/material.dart';

class productwishlistscreen extends StatefulWidget {
  final Set<String> favorites; // Named parameter

  // Constructor to accept favorites
  productwishlistscreen({required this.favorites});

  @override
  _ProductWishlistScreenState createState() => _ProductWishlistScreenState();
}

class _ProductWishlistScreenState extends State<productwishlistscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: widget.favorites.isEmpty
          ? Center(child: Text("No favorites yet!"))
          : ListView(
        children: widget.favorites.map((product) {
          return ListTile(
            title: Text(product),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  // Remove from favorites
                  widget.favorites.remove(product);
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

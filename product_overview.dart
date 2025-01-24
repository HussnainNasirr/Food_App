import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;

  ProductOverview({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
  });

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool wishListBool = false;

  @override
  void initState() {
    super.initState();
    getWishListBool();
  }

  void getWishListBool() {
    FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get()
        .then((value) {
      if (mounted && value.exists) {
        setState(() {
          wishListBool = value.get("wishList");
        });
      }
    });
  }

  void addToWishList() {
    setState(() {
      wishListBool = !wishListBool;
    });
    if (wishListBool) {
      FirebaseFirestore.instance
          .collection("WishList")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("YourWishList")
          .doc(widget.productId)
          .set({
        "wishList": true,
        "productId": widget.productId,
        "productName": widget.productName,
        "productPrice": widget.productPrice,
        "productImage": widget.productImage,
      });
    } else {
      FirebaseFirestore.instance
          .collection("WishList")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("YourWishList")
          .doc(widget.productId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Overview", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductWishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(widget.productName),
            subtitle: Text("\$${widget.productPrice}"),
          ),
          Image.network(widget.productImage),
          ElevatedButton(
            onPressed: addToWishList,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(wishListBool ? Icons.favorite : Icons.favorite_border),
                SizedBox(width: 5),
                Text("Add to Wishlist"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductWishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Favourite")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("WishList")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("YourWishList")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No items in wishlist"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  leading: Image.network(item['productImage'], width: 50, fit: BoxFit.cover),
                  title: Text(item['productName']),
                  subtitle: Text("\$${item['productPrice']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("WishList")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("YourWishList")
                          .doc(item['productId'])
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

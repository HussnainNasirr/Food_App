import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/rating_and_review.dart';
import 'package:food_app/splash_screen.dart';
import 'sign_in.dart';
import 'payment_method.dart';
import 'my_orders.dart';
import 'view_all_screens.dart';
import 'package:food_app/Product_Wishlist_Screen.dart' ;
import 'google_map.dart';


// Checkout function to save order details to Firestore
void checkoutOrder(BuildContext context) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please sign in to place an order')),
    );
    return;
  }

  final orderId = DateTime.now().millisecondsSinceEpoch.toString();
  final totalAmount = cartItems.fold(0, (sum, item) => sum + item.priceInt * item.quantity);

  final List<Map<String, dynamic>> items = cartItems.map((item) {
    return {
      "name": item.name,
      "price": item.price,
      "imageUrl": item.imageUrl,
      "quantity": item.quantity,
      "totalPrice": item.totalPrice,
    };
  }).toList();

  FirebaseFirestore.instance
      .collection("Orders")
      .doc(userId)
      .collection("UserOrders")
      .doc(orderId)
      .set({
    "orderId": orderId,
    "totalAmount": totalAmount,
    "orderDate": DateTime.now().toIso8601String(),
    "items": items,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully')),
    );
    cartItems.clear();  // Clear the cart
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to place order: $error')),
    );
  });
}
// A simple model for cart items
class CartItem {
  final String name;
  final String price;
  final String imageUrl;
  int quantity;
  bool isFavorite;  // New property to mark item as favorite

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isFavorite = false,  // Initialize isFavorite as false by default
  });

  // Convert price string to an integer for calculation
  int get priceInt => int.parse(price.replaceAll(RegExp(r'\D'), ''));

  // Get the total price of the item based on its quantity
  String get totalPrice => 'Rs.${(priceInt * quantity).toString()}';
}

// Global cart list to simulate backend storage
List<CartItem> cartItems = [];

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Center(child: Text("Sign In Screen")),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    int totalAmount = cartItems.fold(0, (sum, item) => sum + item.priceInt * item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Color(0xffd6b738),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(  // Ensure this is scrollable
        child: Column(
          children: cartItems.map((item) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Image.asset(item.imageUrl, width: 50, height: 50),
                title: Text(item.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.price),
                    Text("Total: ${item.totalPrice}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (item.quantity > 1) {
                            item.quantity--;
                          }
                        });
                      },
                    ),
                    Text(item.quantity.toString(), style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          cartItems.remove(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} removed from cart')),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rs.$totalAmount',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the payment method screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentMethod(totalAmount: totalAmount)),
                  ).then((_) {
                    setState(() {
                      cartItems.clear();  // Clear cart after payment
                    });
                  });
                },
                child: Text('Checkout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState(); // Correct way to create the state
}
class _HomeScreenState extends State<HomeScreen> {
  Set<String> favorites = Set();
  // Toggle the favorite status
  void toggleFavorite(String product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
      } else {
        favorites.add(product);
      }

    });
  }
  Widget singleProduct(BuildContext context, String imageUrl, String name, String price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 230,
      width: 160,
      decoration: BoxDecoration(
        color: Color(0xffd9dad9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Text(price, style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        favorites.contains(name) ? Icons.favorite : Icons.favorite_border,
                        color: favorites.contains(name) ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        toggleFavorite(name);  // Toggle favorite when pressed
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          cartItems.add(CartItem(name: name, price: price, imageUrl: imageUrl));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name added to cart')),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Add To Cart", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              Icon(Icons.wallet_travel_outlined, size: 20, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcbcbcb),

      drawer: Drawer(
        child: Container(
          color: Color(0xffd1ad17),
          child: ListView(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white54,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.red,
                        child: Image.asset(
                          'assets/logo.jpg',
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Malik Foods"),
                        SizedBox(height: 7),
                        Container(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text("Home"),

              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text("My Location"),  // Change the title if needed
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleMapScreen()),  // Replace with your GoogleMapScreen widget
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("My Orders"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  MyOrders()),  // Replace with your GoogleMapScreen widget
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text("Notification"),
              ),
              ListTile(
                leading: Icon(Icons.star_outline),
                title: Text("Rating & Review"),
                onTap: () {
                  // Navigate to RatingAndReviewScreen when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RatingAndReviewScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_outline),
                title: Text("My Favorites"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => productwishlistscreen(favorites: favorites), // Pass the favorites set here
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.copy_outlined),
                title: Text("Raise a Complaint"),
              ),
              ListTile(
                leading: Icon(Icons.format_quote_outlined),
                title: Text("FAQs"),
              ),
              Container(
                height: 350,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact Support"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Call us:"),
                        SizedBox(width: 10),
                        Text("+923150700667"),
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text("Mail us:"),
                          SizedBox(width: 10),
                          Text("malikfoodsgmail.com"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Cart"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app), // Icon for the list tile
                title: Text("Sign Out"), // Label for the sign-out button
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SplashScreen(nextPage: LoginPage()), // Make sure this leads to the right screen
                    ),
                  );
                },
              ),

            ],

          ),
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Home", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black), onPressed: () {  },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
        backgroundColor: Color(0xffd6b738),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://miro.medium.com/v2/resize:fit:696/0*4AYreHttN4UsITDH'),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffd1ad17),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Malik Foods",
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("30% Off", style: TextStyle(fontSize: 35, color: Colors.green[100], fontWeight: FontWeight.bold)),
                        Text("On This Deal", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Starters", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllStartersScreen()));
                    },
                    child: Text("View All", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  singleProduct(context, 'assets/wings.jpeg', 'Spicy Wings', 'Rs.350/'),
                  singleProduct(context, 'assets/garlic.jpeg', 'Garlic Bread', 'Rs.180/'),
                  singleProduct(context, 'assets/cheese.jpeg', 'Cheese Balls', 'Rs.400/'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Paratha & Shawarma Roll", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllParathaRollScreen()));
                    },
                    child: Text("View All", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  singleProduct(context, 'assets/Zingerparatha.jpg', 'Zinger Paratha', 'Rs.150/'),
                  singleProduct(context, 'assets/rollshawarma.jpg', 'Chicken Shawarma Roll', 'Rs.250/'),
                  singleProduct(context, 'assets/beefshawarma.jpg', 'Beef Shawarma Roll', 'Rs.300/'),
                  singleProduct(context, 'assets/malaiboti.jpg', 'Malai Boti Paratha', 'Rs.320'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fried & Burgers", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllFriedBurgersScreen()));
                    },
                    child: Text("View All", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  singleProduct(context, 'assets/thunderburger.jpg', 'Special Thunder Burger', 'Rs.450/'),
                  singleProduct(context, 'assets/beefburger.jpg', 'Beef Burger', 'Rs.650/'),
                  singleProduct(context, 'assets/zingerburger.jpg', 'Zinger Burger', 'Rs.380/'),
                  singleProduct(context, 'assets/hotwings.jpg', 'Hot Wings', '(10 pcs) Rs.550'),
                  singleProduct(context, 'assets/ovenbakedwings.jpg', 'Oven Baked Wings', '(10 pcs) Rs.600'),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}


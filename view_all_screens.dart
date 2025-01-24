import 'package:flutter/material.dart';

class ViewAllStartersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Starters')),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/wings.jpeg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Spicy Wings'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.350/'),
                SizedBox(height: 5),
                Text(
                  'Crispy, spicy wings served with a tangy sauce. Perfect for spice lovers!',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/garlic.jpeg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Garlic Bread'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.180/'),
                SizedBox(height: 5),
                Text(
                  'Golden, crispy bread topped with garlic butter. A classic appetizer!',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/cheese.jpeg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Cheese Balls'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.400/'),
                SizedBox(height: 5),
                Text(
                  'Deep-fried cheese balls with a crispy outer layer and gooey cheese inside.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAllParathaRollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Paratha & Shawarma Rolls')),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/Zingerparatha.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Zinger Paratha'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.150/'),
                SizedBox(height: 5),
                Text(
                  'Spicy zinger fillet wrapped in a soft paratha, perfect for a quick meal.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/rollshawarma.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Chicken Shawarma Roll'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.250/'),
                SizedBox(height: 5),
                Text(
                  'Tender chicken shawarma wrapped in a soft paratha. A delightful roll!',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/beefshawarma.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Beef Shawarma Roll'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.300/'),
                SizedBox(height: 5),
                Text(
                  'Beef shawarma with spicy sauce and veggies, rolled in soft paratha.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/malaiboti.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Malai Boti Paratha'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.320/'),
                SizedBox(height: 5),
                Text(
                  'Succulent malai boti wrapped in a soft paratha, packed with flavor.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAllFriedBurgersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Fried & Burgers')),
      body: ListView(
        children: [
          ListTile(
            leading: Image.asset(
              'assets/thunderburger.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Special Thunder Burger'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.450/'),
                SizedBox(height: 5),
                Text(
                  'Juicy beef patty with special thunder sauce, lettuce, and cheese.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/beefburger.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Beef Burger'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.650/'),
                SizedBox(height: 5),
                Text(
                  'A classic beef burger with lettuce, tomato, and cheese.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/zingerburger.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Zinger Burger'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rs.380/'),
                SizedBox(height: 5),
                Text(
                  'Crispy chicken patty with lettuce and spicy sauce.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/hotwings.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Hot Wings'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('(10 pcs) Rs.550'),
                SizedBox(height: 5),
                Text(
                  'Crispy wings coated in a spicy sauce, served in a portion of 10 pieces.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/ovenbakedwings.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text('Oven Baked Wings'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('(10 pcs) Rs.600'),
                SizedBox(height: 5),
                Text(
                  'Oven-baked wings, a healthier alternative to fried wings, with spicy seasoning.',
                  style: TextStyle(fontSize: 16),  // Increased font size for description
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewAllStartersScreen(), // Change this based on your app flow
  ));
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_orders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentMethod(),
    );
  }
}

class PaymentMethod extends StatefulWidget {
final  totalAmount;

  const PaymentMethod({super.key, this.totalAmount});
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 16 || !RegExp(r'^\d{16}$').hasMatch(value)) {
      return 'Please enter a valid 16-digit card number.';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Please enter a valid expiry date (MM/YY).';
    }
    List<String> parts = value.split('/');
    int month = int.parse(parts[0]);
    if (month < 1 || month > 12) {
      return 'Please enter a valid month (01-12).';
    }
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty || value.length != 3 || !RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'Please enter a valid 3-digit CVV.';
    }
    return null;
  }

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in.')));
        return;
      }

      DateTime currentDate = DateTime.now();
      List<String> expiry = _expiryDateController.text.split('/');
      int expiryMonth = int.parse(expiry[0]);
      int expiryYear = int.parse(expiry[1]);
      int fullExpiryYear = 2000 + expiryYear;

      if (DateTime(fullExpiryYear, expiryMonth).isBefore(currentDate)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your card has expired!')));
        return;
      }

      // Example cart items for this order
      List<Map<String, dynamic>> cartItems = [
        {'name': 'Item 1', 'quantity': 2, 'price': widget.totalAmount, 'imageUrl': 'https://via.placeholder.com/150'},
        {'name': 'Item 2', 'quantity': 1, 'price': widget.totalAmount, 'imageUrl': 'https://via.placeholder.com/150'},
      ];

      // Calculate total amount based on cart items
      double totalAmount = cartItems.fold(
        0,
            (sum, item) => sum + (item['price'] * item['quantity']),
      );

      try {
        // Save payment details to Firestore
        final paymentDoc = await FirebaseFirestore.instance.collection('payments').add({
          'userId': user.uid,
          'cardNumber': _cardNumberController.text,
          'expiryDate': _expiryDateController.text,
          'cvv': _cvvController.text,
          'totalAmount': totalAmount,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Save order details to Firestore
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': user.uid,
          'orderId': paymentDoc.id,
          'totalAmount': totalAmount,
          'orderDate': FieldValue.serverTimestamp(),
          'cartItems': cartItems,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful! Total Amount: Rs. $totalAmount')),
        );

        // Navigate to MyOrders screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyOrders()));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regular Membership Payment'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Payment Instructions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
              ),
              SizedBox(height: 10),
              Text(
                '1. Enter your payment details below.\n'
                    '2. Click the "Submit Payment" button to complete your purchase.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: TextStyle(color: Colors.blue.shade900),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                keyboardType: TextInputType.number,
                validator: validateCardNumber,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        labelStyle: TextStyle(color: Colors.blue.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: validateExpiryDate,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: Colors.blue.shade900),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                      keyboardType: TextInputType.number,
                      validator: validateCVV,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit Payment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

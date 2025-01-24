import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RatingAndReviewScreen extends StatefulWidget {
  @override
  _RatingAndReviewScreenState createState() => _RatingAndReviewScreenState();
}

class _RatingAndReviewScreenState extends State<RatingAndReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _feedbackType = 'Suggestions';
  String _category = 'Late Order';

  List<String> feedbackTypes = ['Suggestions', 'Questions', 'Comments'];
  List<String> categories = ['Late Order', 'Hospitality', 'Food Quality'];

  // Submit the feedback to Firestore
  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      // Get the current timestamp
      Timestamp timestamp = Timestamp.now();

      // Get the current user's ID (optional)
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Anonymous';

      // Save feedback to Firestore
      FirebaseFirestore.instance.collection('feedback').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'feedbackType': _feedbackType,
        'category': _category,
        'message': _messageController.text,
        'timestamp': timestamp,
        'userId': userId, // Optional: Store the user ID for tracking
      }).then((value) {
        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feedback Submitted Successfully!')));
        // Clear the fields after submission
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting feedback: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating & Review'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number (+92)'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 13) {
                    return 'Please enter a valid phone number with country code (+92)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Feedback Type Dropdown
              DropdownButtonFormField<String>(
                value: _feedbackType,
                decoration: InputDecoration(labelText: 'Feedback Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    _feedbackType = newValue!;
                  });
                },
                items: feedbackTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Message Field
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Your Message'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit Feedback'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

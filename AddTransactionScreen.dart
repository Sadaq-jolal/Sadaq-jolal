import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _addTransaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      if (_amountController.text.isEmpty || _descriptionController.text.isEmpty) {
        throw Exception('Amount and description cannot be empty');
      }
      await _firestore.collection('transactions').add({
        'amount': double.parse(_amountController.text).toStringAsFixed(2),
        'description': _descriptionController.text,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add transaction: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _addTransaction,
              child: Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 36),
                padding: EdgeInsets.symmetric(vertical: 10),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

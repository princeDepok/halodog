import 'package:flutter/material.dart';
import 'package:frontend/screens/list_animals.dart';
import 'package:intl/intl.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/screens/auth/sign_in.dart';

class ReviewSummaryPage extends StatelessWidget {
  final Map<String, dynamic> selectedDoctor;
  final String selectedDuration;
  final String selectedPackage;
  final int totalPrice;

  const ReviewSummaryPage({
    Key? key,
    required this.selectedDoctor,
    required this.selectedDuration,
    required this.selectedPackage,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    String formattedTime = DateFormat('hh:mm a').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Review Summary',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(selectedDoctor['picture']),
                    backgroundColor: Colors.orange[50],
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedDoctor['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  InfoRow(label: 'Date & Hour', value: '$formattedDate | $formattedTime'),
                  Divider(),
                  InfoRow(label: 'Package', value: selectedPackage),
                  Divider(),
                  InfoRow(label: 'Duration', value: selectedDuration),
                  Divider(),
                  InfoRow(label: 'Total Price', value: 'Rp$totalPrice'),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                TokenStorage tokenStorage = TokenStorage();
                bool isGuest = await tokenStorage.isGuest();
                if (isGuest) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListAnimals(
                      selectedDoctor: selectedDoctor,
                      selectedDuration: selectedDuration,
                      selectedPackage: selectedPackage,
                      totalPrice: totalPrice,
                    )),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffF4A261),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Select Animal', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

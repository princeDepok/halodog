// select_package.dart

import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/summary.dart';
import 'package:frontend/utils/button.dart';

class SelectPackageScreen extends StatefulWidget {
  final Map<String, dynamic> selectedDoctor;

  const SelectPackageScreen({required this.selectedDoctor});

  @override
  _SelectPackageScreenState createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  String _selectedDuration = '30 minutes';
  String _selectedPackage = '';
  List<String> _durations = ['30 minutes', '60 minutes', '90 minutes'];

  void _navigateToHome() {
    Navigator.pop(context);
  }

  void _selectPackage(String package) {
    setState(() {
      _selectedPackage = package;
    });
  }

  void _navigateToReviewSummary() {
    if (_selectedPackage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a package.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSummaryPage(
          selectedDoctor: widget.selectedDoctor,
          selectedDuration: _selectedDuration,
          selectedPackage: _selectedPackage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _navigateToHome();
          },
        ),
        title: Text(
          'Select Package',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Duration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: _selectedDuration,
              items: _durations.map((String duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text(duration),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value.toString();
                });
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Package',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            PackageOption(
              icon: Icons.message,
              title: 'Messaging',
              subtitle: 'Chat messages with doctor',
              isSelected: _selectedPackage == 'Messaging',
              onTap: () => _selectPackage('Messaging'),
            ),
            SizedBox(height: 10),
            PackageOption(
              icon: Icons.phone,
              title: 'Voice Call',
              subtitle: 'Voice Call with doctor',
              isSelected: _selectedPackage == 'Voice Call',
              onTap: () => _selectPackage('Voice Call'),
            ),
            SizedBox(height: 10),
            PackageOption(
              icon: Icons.video_call,
              title: 'Video Call',
              subtitle: 'Video Call with doctor',
              isSelected: _selectedPackage == 'Video Call',
              onTap: () => _selectPackage('Video Call'),
            ),
            Spacer(),
            CustomButton(
              text: 'Next',
              onPressed: _navigateToReviewSummary,
            ),
          ],
        ),
      ),
    );
  }
}

class PackageOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PackageOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.orange, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.orange),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

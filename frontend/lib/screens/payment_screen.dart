import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/core/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/token_storage.dart';
import 'booking_model.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;

  PaymentScreen({required this.booking});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String _bcaAccountNumber = "1234567890";
  File? _paymentProof;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _paymentProof = File(pickedFile.path);
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _bcaAccountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('BCA account number copied to clipboard')),
    );
  }

  void _confirmBooking() async {
    if (_paymentProof == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload payment proof')),
      );
      return;
    }

    final accessToken = await TokenStorage().getAccessToken();
    if (accessToken == null) {
      // Handle user not logged in
      return;
    }

    final booking = widget.booking;
    booking.paymentProof = _paymentProof;

    final response = await ApiService().createBooking(booking, accessToken);
    if (response.statusCode == 201) {
      // Booking success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${response.statusMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Payment', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/Logo_BCA.png', height: 50), // Replace with the correct path to your image
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nomor Rekening BCA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(_bcaAccountNumber, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: Icon(Icons.copy, color: Colors.white),
                        label: Text('Copy', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400], // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Rp${widget.booking.totalPrice.toString()}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Upload Bukti Pembayaran', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 10),
            Text('Tipe File yang digunakan Png/Jpg', style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 20),
            _paymentProof == null
                ? Text('No payment proof selected.', style: TextStyle(color: Colors.red))
                : Image.file(_paymentProof!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

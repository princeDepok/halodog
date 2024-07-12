import 'package:flutter/material.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/token_storage.dart';
import 'add_animal.dart';
import 'payment_screen.dart';
import 'booking_model.dart';

class ListAnimals extends StatefulWidget {
  final Map<String, dynamic> selectedDoctor;
  final String selectedDuration;
  final String selectedPackage;
  final int totalPrice;

  const ListAnimals({
    Key? key,
    required this.selectedDoctor,
    required this.selectedDuration,
    required this.selectedPackage,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _ListAnimalsState createState() => _ListAnimalsState();
}

class _ListAnimalsState extends State<ListAnimals> {
  final ApiService _apiService = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();
  List<dynamic> _pets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      final pets = await _apiService.getUserPets(accessToken);
      setState(() {
        _pets = pets;
      });
    }
  }

  void _navigateToPayment(String petName) async {
    final userId = await _tokenStorage.getUserId();
    final totalPrice = widget.totalPrice; // Ensure totalPrice is passed correctly
    final duration = int.tryParse(widget.selectedDuration) ?? 0; // Ensure duration is passed correctly

    final booking = Booking(
      userId: userId!,
      petName: petName,
      vetName: widget.selectedDoctor['name'],
      package: widget.selectedPackage,
      duration: duration,
      totalPrice: totalPrice,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('My Pets', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _pets.isEmpty
                  ? Center(child: Text('No pets found.'))
                  : ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, index) {
                        final pet = _pets[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: pet['photo'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(pet['photo']),
                                    radius: 30,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.orange[100],
                                    radius: 30,
                                    child: Icon(Icons.pets, color: Colors.orange),
                                  ),
                            title: Text(
                              pet['name'].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              '${pet['age']} Bulan\n${pet['species']} - ${pet['breed']}',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            tileColor: Colors.orange[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            onTap: () => _navigateToPayment(pet['name']),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAnimal()),
                  );
                  if (result == true) {
                    _fetchPets();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Add New Animal', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: 'For More Information go to ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'consultation',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

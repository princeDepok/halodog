// doctor_list.dart

import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/select_package.dart';
import 'package:frontend/services/api_services.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  int selectedRating = 0;
  String searchQuery = '';
  List<dynamic> doctors = [];
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final data = await _apiService.getDoctors();
    setState(() {
      doctors = data;
      isLoading = false;
    });
  }

  void _navigateToSelectPackage(Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectPackageScreen(selectedDoctor: doctor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Doctor'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 383,
            height: 61,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                    color: Colors.white), // Mengatur warna teks hint menjadi putih
                prefixIcon: Icon(Icons.search,
                    color: Colors.white), // Mengatur warna ikon menjadi putih
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // Menghapus border
                ),
                filled: true,
                fillColor: Color(
                    0xFFFF8C02), // Mengatur warna latar belakang menjadi #FF8C02
              ),
              style: TextStyle(
                  color: Colors.white), // Mengatur warna teks input menjadi putih
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ratingFilterButton(0, 'All'),
                ratingFilterButton(5, '5'),
                ratingFilterButton(4, '4'),
                ratingFilterButton(3, '3'),
                ratingFilterButton(2, '2'),
                ratingFilterButton(1, '1'),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: doctors
                        .where((doctor) =>
                            (selectedRating == 0 || doctor['rating'] == selectedRating) &&
                            (searchQuery.isEmpty ||
                                doctor['name']
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase())))
                        .map((doctor) => doctorCard(doctor))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget ratingFilterButton(int rating, String label) {
    bool isSelected = selectedRating == rating;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = rating;
        });
      },
      child: Container(
        width: 56,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFF8C02) : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Color(0xFFFF8C02),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFFFF8C02),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.star,
                color: Colors.white,
                size: 16,
              ),
            if (!isSelected)
              Icon(
                Icons.star_border,
                color: Color(0xFFFF8C02),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(Map<String, dynamic> doctor) {
    return GestureDetector(
      onTap: () {
        _navigateToSelectPackage(doctor);
      },
      child: Card(
        color: Color(0xFFFF8C02),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(doctor['picture']),
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        // Reset image URL or handle error case
                        doctor['picture'] = 'assets/images/default_picture.png'; // Set to default image path
                      });
                    },
                    child: Icon(Icons.person, color: Color(0xFFFF8C02)),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        doctor['specialty'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          doctor['rating'].toString(),
                          style: TextStyle(color: Color(0xFFFF8C02)),
                        ),
                        Icon(Icons.star, color: Color(0xFFFF8C02), size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                doctor['description'],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

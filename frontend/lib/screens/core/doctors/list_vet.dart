import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/select_package.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/utils/vet_item.dart';

class DoctorList extends StatefulWidget {
  final String specialty;
  const DoctorList({super.key, required this.specialty});

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
    try {
      final data = await _apiService.getDoctors();
      print('Fetched doctors data: $data');
      setState(() {
        doctors = data.where((doctor) {
          final specialties = doctor['specialties'] as List<dynamic>?;
          print('Doctor specialties: $specialties');
          return widget.specialty == 'All' ||
              (specialties?.any((specialty) =>
                      specialty is String && specialty == widget.specialty ||
                      specialty is Map && specialty['name'] == widget.specialty) ??
                  false);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching doctors: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xffF4A261),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Row(
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
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : doctors.isEmpty
                      ? Center(child: Text('No doctors available for the selected specialty.'))
                      : ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: VetDoctorItem(doctor: doctor),
                            );
                          },
                        ),
            ),
          ],
        ),
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
          color: isSelected ? Color(0xffF4A261) : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Color(0xffF4A261),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xffF4A261),
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
                color: Color(0xffF4A261),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

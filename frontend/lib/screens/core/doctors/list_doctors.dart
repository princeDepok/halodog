// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  int selectedRating = 0;

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Dr. Johnson',
      'date': '12 April 2023',
      'review':
          'Dr. Johnson is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 5,
    },
    {
      'name': 'Dr. Jessy Andini',
      'date': '12 April 2023',
      'review':
          'Dr. Jessy Andini is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 5,
    },
    {
      'name': 'Dr. Jessika',
      'date': '12 April 2023',
      'review':
          'Dr. Jessika is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 4,
    },
    {
      'name': 'Dr. Tania',
      'date': '12 April 2023',
      'review':
          'Dr. Tania is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 5,
    },
    {
      'name': 'Dr. Ismail',
      'date': '12 April 2023',
      'review':
          'Dr. Ismail is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 5,
    },
    {
      'name': 'Dr. Budi Subanto',
      'date': '12 April 2023',
      'review':
          'Dr. Budi Subanto is very professional in his work and responsive. I have consulted and my probe is solved! Thank You!',
      'rating': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Doctor'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
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
            child: ListView(
              children: reviews
                  .where((review) =>
                      selectedRating == 0 || review['rating'] == selectedRating)
                  .map((review) => doctorReviewCard(review))
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

  Widget doctorReviewCard(Map<String, dynamic> review) {
    return Card(
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
                  child: Icon(Icons.person, color: Color(0xFFFF8C02)),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      review['date'],
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
                        review['rating'].toString(),
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
              review['review'],
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoctorList(),
  ));
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/select_package.dart';
import 'package:frontend/screens/core/shop/pet_shop.dart';
import 'package:frontend/utils/article.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hello, Arifin 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 35),
            Container(
              width: 383,
              height: 61,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      color: Colors
                          .white), // Mengatur warna teks hint menjadi putih
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
                    color: Colors
                        .white), // Mengatur warna teks input menjadi putih
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateToPage(context, SelectPackageScreen());
                      },
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8C02),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.medical_services,
                            size: 36, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8), // Memberi jarak antara ikon dan teks
                    Text('Consult',
                        style: TextStyle(
                            color: Colors
                                .black)), // Menambahkan teks di bawah ikon
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // navigateToPage(context, BookingPage());
                      },
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8C02),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.book_online,
                            size: 36, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Booking', style: TextStyle(color: Colors.black)),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateToPage(context, PetShopScreen());
                      },
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8C02),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.pets, size: 36, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Petshop', style: TextStyle(color: Colors.black)),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // navigateToPage(context, InpatientPage());
                      },
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8C02),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.local_hospital,
                            size: 36, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Inpatient', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 35),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ArticleCard(
                    imageUrl:
                        'https://via.placeholder.com/150', // Replace with actual image URL
                    title: 'COVID-19 Was a Top cause of Death in 2020 and 2021',
                  ),
                  ArticleCard(
                    imageUrl:
                        'https://via.placeholder.com/150', // Replace with actual image URL
                    title: 'Study finds being \'Hangry\' is a Real Thing',
                  ),
                  ArticleCard(
                    imageUrl:
                        'https://via.placeholder.com/150', // Replace with actual image URL
                    title: 'COVID-19 Was a Top cause of Death in 2020 and 2021',
                  ),
                  ArticleCard(
                    imageUrl:
                        'https://via.placeholder.com/150', // Replace with actual image URL
                    title: 'Study finds being \'Hangry\' is a Real Thing',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

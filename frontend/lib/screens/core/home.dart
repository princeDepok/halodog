import 'package:flutter/material.dart';
import 'package:frontend/screens/core/doctors/list_vet.dart';
import 'package:frontend/screens/core/doctors/vet_details.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/utils/custom_menubar.dart';
import 'package:frontend/screens/more_page.dart';
import 'package:frontend/utils/vet_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Placeholder(),
    const Placeholder(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomMenuBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = 'Guest';
  final TokenStorage _tokenStorage = TokenStorage();
  final ApiService _apiService = ApiService();
  bool isGuest = true;
  List<dynamic> vetDoctors = [];

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    _fetchVetDoctors();
  }

  Future<void> _checkUserStatus() async {
    isGuest = await _tokenStorage.isGuest();
    if (!isGuest) {
      _fetchUserData();
    } else {
      setState(() {
        username = 'Guest';
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      final userId = await _tokenStorage.getUserId();
      if (accessToken != null && userId != null) {
        final response =
            await _apiService.getUserDetails(int.parse(userId), accessToken);
        if (response.statusCode == 200) {
          setState(() {
            username = response.data['username'] ?? 'User';
          });
        } else {
          print('Failed to fetch user details: ${response.data}');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchVetDoctors() async {
    try {
      final doctors = await _apiService.getDoctors();
      setState(() {
        vetDoctors = doctors;
      });
    } catch (e) {
      print('Error fetching vet doctors: $e');
    }
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateToDoctorDetails(BuildContext context, dynamic doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VetDetails(doctor: doctor)),
    );
  }

  void navigateToDoctorList(BuildContext context, String specialty) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoctorList(specialty: specialty)),
    );
  }

  Widget _buildConsultationItem(
      BuildContext context, String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        navigateToDoctorList(context, label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hello, $username 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 383,
                  height: 61,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by doctor name/code',
                      hintStyle: const TextStyle(
                        color: Color(0xFF77838F),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF77838F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2DFDF),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2DFDF),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFFE2DFDF),
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF77838F),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Your next appointment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "You don't have any appointment",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Consultation For',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildConsultationItem(
                        context, 'Dog', Icons.pets, Color(0xffF4A261)),
                    _buildConsultationItem(
                        context, 'Cat', Icons.pets, Color(0xffF4A261)),
                    _buildConsultationItem(
                        context, 'Bird', Icons.pets, Color(0xffF4A261)),
                    _buildConsultationItem(
                        context, 'Hamster', Icons.pets, Color(0xffF4A261)),
                    _buildConsultationItem(
                        context, 'Rabbit', Icons.pets, Color(0xffF4A261)),
                    _buildConsultationItem(
                        context, 'All', Icons.more_horiz, Color(0xffF4A261)),
                  ],
                ),
                const SizedBox(height: 35),
                Text(
                  "Veterinary",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vetDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = vetDoctors[index];
                    return GestureDetector(
                      onTap: () => navigateToDoctorDetails(context, doctor),
                      child: Column(
                        children: [
                          VetDoctorItem(doctor: doctor),
                          SizedBox(height: 10), // Add spacing between items
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

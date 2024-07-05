import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/select_package.dart';
import 'package:frontend/screens/core/doctors/list_doctors.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/utils/article.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:frontend/utils/custom_menubar.dart';
import 'package:frontend/screens/more_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    // Add other screens here
    Placeholder(),
    Placeholder(),
    MorePage(),
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
  String username = 'Guest'; // Default to 'Guest'
  final TokenStorage _tokenStorage = TokenStorage();
  final ApiService _apiService = ApiService();
  bool isGuest = true;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
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
        final response = await _apiService.getUserDetails(int.parse(userId), accessToken);
        if (response.statusCode == 200) {
          setState(() {
            username = response.data['username'] ?? 'User'; // Use 'User' if username is not available
          });
        } else {
          print('Failed to fetch user details: ${response.data}');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hello, $username 👋',
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
          SizedBox(height: 35),
          Container(
            height: 153,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              'assets/images/banner.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateToPage(context, DoctorList());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8C02),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.medical_services,
                          size: 48, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Consult',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isGuest) {
                        Navigator.pushNamed(context, '/sign_in'); // Redirect to sign-in page if guest
                      } else {
                        // Add your BookingPage navigation here
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8C02),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.book_online,
                          size: 48, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Booking', style: TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
          SizedBox(height: 35),
          Expanded(
            child: ListView(
              children: <Widget>[
                ArticleCard(
                  imageUrl: 'assets/images/news1.png',
                  title: 'COVID-19 Was a Top cause of Death in 2020 and 2021',
                ),
                ArticleCard(
                  imageUrl: 'assets/images/news1.png',
                  title: 'Study finds being \'Hangry\' is a Real Thing',
                ),
                ArticleCard(
                  imageUrl: 'assets/images/news1.png',
                  title: 'COVID-19 Was a Top cause of Death in 2020 and 2021',
                ),
                ArticleCard(
                  imageUrl: 'assets/images/news2.png',
                  title: 'Study finds being \'Hangry\' is a Real Thing',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

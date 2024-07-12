import 'package:flutter/material.dart';
import 'package:frontend/screens/core/consult/summary.dart';

class VetDetails extends StatefulWidget {
  final dynamic doctor;

  const VetDetails({Key? key, required this.doctor}) : super(key: key);

  @override
  _VetDetailsState createState() => _VetDetailsState();
}

class _VetDetailsState extends State<VetDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChatTime;
  String? _selectedCallTime;
  String? _selectedPackage;
  int _totalChatPrice = 0;
  int _totalCallPrice = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_setSelectedPackage);
  }

  @override
  void dispose() {
    _tabController.removeListener(_setSelectedPackage);
    _tabController.dispose();
    super.dispose();
  }

  void _setSelectedPackage() {
    setState(() {
      if (_tabController.index == 0) {
        _selectedPackage = 'Chat';
      } else if (_tabController.index == 1) {
        _selectedPackage = 'Video Call';
      } else if (_tabController.index == 2) {
        _selectedPackage = 'Clinic Appointment';
      }
    });
  }

  void _updateChatPrice() {
    if (_selectedChatTime != null) {
      double basePrice = double.tryParse(widget.doctor['chat_consultation_fee']) ?? 0.0;
      switch (_selectedChatTime) {
        case '15 minutes':
          _totalChatPrice = basePrice.toInt();
          break;
        case '30 minutes':
          _totalChatPrice = (basePrice * 2).toInt();
          break;
        case '60 minutes':
          _totalChatPrice = (basePrice * 4).toInt();
          break;
      }
    }
  }

  void _updateCallPrice() {
    if (_selectedCallTime != null) {
      double basePrice = double.tryParse(widget.doctor['voice_call_consultation_fee']) ?? 0.0;
      switch (_selectedCallTime) {
        case '30 minutes':
          _totalCallPrice = basePrice.toInt();
          break;
        case '45 minutes':
          _totalCallPrice = (basePrice / 30 * 45).toInt();
          break;
        case '60 minutes':
          _totalCallPrice = (basePrice * 2).toInt();
          break;
      }
    }
  }

  void _navigateToSummary() {
    int totalPrice = 0;
    int duration = 0;

    if (_selectedPackage == 'Chat') {
      totalPrice = _totalChatPrice;
      duration = _selectedChatTime == '15 minutes' ? 15 : _selectedChatTime == '30 minutes' ? 30 : 60;
    } else if (_selectedPackage == 'Video Call') {
      totalPrice = _totalCallPrice;
      duration = _selectedCallTime == '30 minutes' ? 30 : _selectedCallTime == '45 minutes' ? 45 : 60;
    } else if (_selectedPackage == 'Clinic Appointment') {
      totalPrice = int.parse(widget.doctor['appointment_fee']);
      duration = 60; // Assuming clinic appointment has a fixed duration
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSummaryPage(
          selectedDoctor: widget.doctor,
          selectedDuration: duration.toString(),
          selectedPackage: _selectedPackage ?? '',
          totalPrice: totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            const Tab(text: 'Chat'),
            const Tab(text: 'Video Call'),
            const Tab(text: 'Clinic Appointment'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: 200,
                  width: double.infinity,
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.doctor['picture']), // Doctor's image
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.doctor['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.doctor['clinic_name'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.doctor['clinic_address'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.doctor['rating']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.doctor['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Experience: ${widget.doctor['experience_years']} years',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Specialties',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSpecialties(widget.doctor['specialties']),
                    const SizedBox(height: 20),
                    Container(
                      height: 300, // Adjusted height to accommodate fee information
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildChatTab(),
                          _buildVideoCallTab(),
                          _buildClinicAppointmentTab(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSelectPackageButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialties(dynamic specialties) {
    // Adding debugging statements
    print('Specialties: $specialties');
    if (specialties != null && specialties is List && specialties.isNotEmpty) {
      // Adding type checks and debugging
      for (var specialty in specialties) {
        print('Specialty type: ${specialty.runtimeType}');
        if (specialty is! Map) {
          print('Invalid specialty format: $specialty');
        }
      }
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: specialties.map<Widget>((specialty) {
          if (specialty is Map && specialty.containsKey('name')) {
            return Chip(
              label: Text(specialty['name']),
            );
          } else {
            return const Chip(
              label: Text('Invalid specialty'),
            );
          }
        }).toList(),
      );
    } else {
      return const Text(
        'No specialties available',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }
  }

  Widget _buildSelectPackageButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _navigateToSummary,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF4A261),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Confirm Package',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedChatTime,
          items: ['15 minutes', '30 minutes', '60 minutes']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedChatTime = newValue;
              _updateChatPrice();
            });
          },
          hint: const Text('Select Time'),
        ),
        const SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['chat_consultation_fee']}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Total Price: Rp$_totalChatPrice',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCallTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedCallTime,
          items: ['30 minutes', '45 minutes', '60 minutes']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCallTime = newValue;
              _updateCallPrice();
            });
          },
          hint: const Text('Select Time'),
        ),
        const SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['voice_call_consultation_fee']}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Total Price: Rp$_totalCallPrice',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildClinicAppointmentTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateItem('19', 'Sat', false),
            _buildDateItem('20', 'Sun', true),
            _buildDateItem('21', 'Mon', false),
            _buildDateItem('22', 'Tue', false),
            _buildDateItem('23', 'Wed', false),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTimeItem('08:00 AM'),
            _buildTimeItem('09:00 AM'),
            _buildTimeItem('10:00 AM'),
            _buildTimeItem('11:00 AM'),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['appointment_fee']}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String date, String day, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7B61FF) : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        time,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTimePackageItem(String package) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        package,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

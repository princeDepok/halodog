// vet_details.dart

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
    if (_selectedPackage == 'Chat') {
      totalPrice = _totalChatPrice;
    } else if (_selectedPackage == 'Video Call') {
      totalPrice = _totalCallPrice;
    } else if (_selectedPackage == 'Clinic Appointment') {
      totalPrice = int.parse(widget.doctor['appointment_fee']);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewSummaryPage(
          selectedDoctor: widget.doctor,
          selectedDuration: _selectedPackage == 'Chat' ? _selectedChatTime ?? '' : _selectedCallTime ?? '',
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Chat'),
            Tab(text: 'Video Call'),
            Tab(text: 'Clinic Appointment'),
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
                      SizedBox(height: 10),
                      Text(
                        widget.doctor['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.doctor['clinic_name'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.doctor['clinic_address'],
                        style: TextStyle(
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2), // changes position of shadow
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
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${widget.doctor['rating']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.doctor['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Experience: ${widget.doctor['experience_years']} years',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Specialities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildSpecialities(widget.doctor['specialties']),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
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

  Widget _buildSpecialities(dynamic specialties) {
    if (specialties is List && specialties.isNotEmpty && specialties[0] is Map) {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: specialties.map<Widget>((specialty) {
          return Chip(
            label: Text(specialty['name']),
          );
        }).toList(),
      );
    } else {
      return Text(
        'No specialities available',
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
              backgroundColor: Color(0xFF7B61FF),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
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
        Text(
          'Select Time Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
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
          hint: Text('Select Time'),
        ),
        SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['chat_consultation_fee']}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Total Price: Rp$_totalChatPrice',
          style: TextStyle(
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
        Text(
          'Select Time Package',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
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
          hint: Text('Select Time'),
        ),
        SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['voice_call_consultation_fee']}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Total Price: Rp$_totalCallPrice',
          style: TextStyle(
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
        Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
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
        SizedBox(height: 20),
        Text(
          'Select Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
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
        SizedBox(height: 20),
        Text(
          'Consultation Fee: Rp${widget.doctor['appointment_fee']}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String date, String day, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF7B61FF) : Colors.grey[200],
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        time,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTimePackageItem(String package) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        package,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

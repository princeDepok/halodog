import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/services/api_services.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddAnimal extends StatefulWidget {
  @override
  _AddAnimalState createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();
  String? _name;
  String? _species;
  String? _breed;
  int? _age;
  String? _description;
  XFile? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _photo = pickedFile;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final accessToken = await _tokenStorage.getAccessToken();
      final userId = await _tokenStorage.getUserId();

      if (accessToken != null && userId != null) {
        final formData = {
          'name': _name,
          'species': _species,
          'breed': _breed,
          'age': _age,
          'description': _description,
          'owner': int.parse(userId!), // Including user ID as owner
        };

        final response = await _apiService.addAnimal(formData, _photo, accessToken);

        if (response.statusCode == 201) {
          // Animal added successfully
          Navigator.pop(context, true); // Indicate success to the previous screen
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add animal: ${response.data}')),
          );
        }
      } else {
        // Handle error: user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Add Animal', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Animal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter the details of your animal below.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextFormField('Name', (value) {
                  _name = value;
                }),
                SizedBox(height: 20),
                _buildTextFormField('Species', (value) {
                  _species = value;
                }),
                SizedBox(height: 20),
                _buildTextFormField('Breed', (value) {
                  _breed = value;
                }),
                SizedBox(height: 20),
                _buildTextFormField('Age', (value) {
                  _age = int.tryParse(value);
                }, keyboardType: TextInputType.number),
                SizedBox(height: 20),
                _buildTextFormField('Description', (value) {
                  _description = value;
                }),
                SizedBox(height: 20),
                Text(
                  'Photo',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: _photo == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Pick a photo',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(File(_photo!.path)),
                              fit: BoxFit.cover),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B61FF), // Consistent color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Add Animal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String) onSaved,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
      onSaved: (value) => onSaved(value!),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

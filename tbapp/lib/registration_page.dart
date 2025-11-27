// lib/registration_page.dart

import 'package:flutter/material.dart';
import 'data_models.dart'; // Ensure data_models.dart contains the Patient class

// --- Enhanced Patient Model (Assuming you update lib/data_models.dart) ---
/*
  class Patient {
    // Existing fields: id, name, age, gender, screening, diagnosisStatus, treatmentRegimen
    
    // NEW FIELDS added to the Patient model in data_models.dart:
    DateTime? dob; 
    String nationalId = '';
    String maritalStatus = '';
    String villageTown = '';
    String district = '';
    String phoneNumber = '';
    String nextOfKinName = '';
    String nextOfKinPhone = '';
    String pastMedicalHistory = ''; 
    String surgicalHistory = '';
    String familyHistory = '';
    String immunizationStatus = '';
    // ...
  }
*/

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Data variables matching the Patient model fields
  String _name = '';
  String? _gender;
  DateTime? _dob;
  String _nationalId = '';
  String? _maritalStatus;
  String _villageTown = '';
  String _district = '';
  String _phoneNumber = '';
  String _nextOfKinName = '';
  String _nextOfKinPhone = '';
  String _pastMedicalHistory = '';
  String _surgicalHistory = '';
  String _familyHistory = '';
  String _immunizationStatus = '';

  // Dropdown options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  // --- Date Picker Function ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  // --- Form Submission and Navigation ---
  void _registerAndScreen(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Calculate age based on DOB (simple calculation)
      final now = DateTime.now();
      int age = _dob != null ? now.year - _dob!.year : 0;
      if (_dob != null) {
        if (now.month < _dob!.month ||
            (now.month == _dob!.month && now.day < _dob!.day)) {
          age--;
        }
      }

      // Create the new patient object with comprehensive data
      final newPatient = Patient(name: _name, age: age, gender: _gender!);

      // Assign all new variables to the patient object
      newPatient.dob = _dob;
      newPatient.nationalId = _nationalId;
      newPatient.maritalStatus = _maritalStatus ?? '';
      newPatient.villageTown = _villageTown;
      newPatient.district = _district;
      newPatient.phoneNumber = _phoneNumber;
      newPatient.nextOfKinName = _nextOfKinName;
      newPatient.nextOfKinPhone = _nextOfKinPhone;
      newPatient.pastMedicalHistory = _pastMedicalHistory;
      newPatient.surgicalHistory = _surgicalHistory;
      newPatient.familyHistory = _familyHistory;
      newPatient.immunizationStatus = _immunizationStatus;

      // Navigate to the screening page, passing the patient object
      Navigator.of(context).pushNamed('/screening', arguments: newPatient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- SECTION 1: Personal & Demographic Data ---
              _buildSectionHeader('Personal & Contact Information 🧑'),

              // Full Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name (Required)',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 10),

              // National ID / Passport Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'National ID / Passport Number',
                ),
                onSaved: (value) => _nationalId = value!,
              ),
              const SizedBox(height: 20),

              // Date of Birth Field
              ListTile(
                title: const Text('Date of Birth (Required)'),
                subtitle: Text(
                  _dob == null
                      ? 'Select Date'
                      : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender (Required)',
                  border: OutlineInputBorder(),
                ),
                items: _genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) =>
                    setState(() => _gender = newValue),
                validator: (value) =>
                    value == null ? 'Gender is required' : null,
                onSaved: (value) => _gender = value!,
              ),
              const SizedBox(height: 10),

              // Marital Status Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Marital Status',
                  border: OutlineInputBorder(),
                ),
                items: _maritalStatusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) =>
                    setState(() => _maritalStatus = newValue),
                onSaved: (value) => _maritalStatus = value!,
              ),
              const SizedBox(height: 30),

              // --- SECTION 2: Address and Contact ---
              _buildSectionHeader('Address and Contact 📞'),

              // Phone Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Primary Phone Number (e.g., +263...)',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value!,
              ),

              // Address: Village/Town
              TextFormField(
                decoration: const InputDecoration(labelText: 'Village / Town'),
                onSaved: (value) => _villageTown = value!,
              ),

              // Address: District
              TextFormField(
                decoration: const InputDecoration(labelText: 'District'),
                onSaved: (value) => _district = value!,
              ),
              const SizedBox(height: 20),

              // Next of Kin Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Next of Kin Name',
                ),
                onSaved: (value) => _nextOfKinName = value!,
              ),

              // Next of Kin Phone
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Next of Kin Phone Number',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _nextOfKinPhone = value!,
              ),
              const SizedBox(height: 30),

              // --- SECTION 3: Medical History ---
              _buildSectionHeader('Medical History 🏥'),

              // Past Medical History
              TextFormField(
                decoration: const InputDecoration(
                  labelText:
                      'Past Medical History (e.g., HIV+, Diabetes, Hypertension)',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSaved: (value) => _pastMedicalHistory = value!,
              ),
              const SizedBox(height: 10),

              // Surgical History
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Surgical History (e.g., Appendectomy, None)',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSaved: (value) => _surgicalHistory = value!,
              ),
              const SizedBox(height: 10),

              // Family History
              TextFormField(
                decoration: const InputDecoration(
                  labelText:
                      'Family History of Chronic Diseases (e.g., TB, Cancer, Diabetes)',
                  hintMaxLines: 3,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSaved: (value) => _familyHistory = value!,
              ),
              const SizedBox(height: 10),

              // Immunization Status
              TextFormField(
                decoration: const InputDecoration(
                  labelText:
                      'Immunization Status (e.g., COVID-19, BCG scar present)',
                ),
                onSaved: (value) => _immunizationStatus = value!,
              ),

              const SizedBox(height: 40),

              // Button to start screening
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Register and Start TB Screening',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () => _registerAndScreen(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

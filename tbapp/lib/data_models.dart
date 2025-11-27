// lib/data_models.dart

class ScreeningData {
  bool hasCough = false;
  int coughDurationWeeks = 0;
  bool hasFever = false;
  bool hasWeightLoss = false;
}

// lib/data_models.dart - UPDATED SECTION

class Patient {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String name = '';
  int age = 0;
  String gender = '';

  // --- NEW FIELDS ---
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
  // ------------------

  ScreeningData screening = ScreeningData();
  String diagnosisStatus = 'Pending Screening';
  String treatmentRegimen = 'N/A';

  Patient({required this.name, required this.age, required this.gender});
}

// ... rest of the file (ScreeningData class)

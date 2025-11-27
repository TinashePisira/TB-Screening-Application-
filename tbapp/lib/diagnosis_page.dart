// lib/diagnosis_page.dart

import 'package:flutter/material.dart';
import 'data_models.dart'; // Ensure Patient and ScreeningData are available

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  // Variables for Lab Results Input
  String? _geneXpertResult; // e.g., MTB Detected, MTB Not Detected
  String? _resistanceStatus; // e.g., Rifampicin Resistant, Susceptible

  // Example list of possible TB-related symptoms, used for the review section
  final List<String> _tbSymptoms = [
    'Persistent cough for 2 weeks or more',
    'Coughing blood (haemoptysis)',
    'Unexplained weight loss',
    'Night sweats',
    'Unexplained fever',
    'Fatigue',
    'Chest pain',
  ];

  // --- Core Diagnosis Logic & Navigation ---
  void _confirmDiagnosis(BuildContext context, Patient patient) {
    if (_geneXpertResult == null) {
      // Basic validation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the GeneXpert/Lab Result.')),
      );
      return;
    }

    String finalDiagnosis;
    if (_geneXpertResult == 'MTB Detected') {
      if (_resistanceStatus == 'Rifampicin Resistant') {
        finalDiagnosis = 'Confirmed DR-TB (Drug-Resistant TB)';
      } else {
        finalDiagnosis = 'Confirmed Active Drug-Sensitive TB';
      }
    } else {
      // If MTB Not Detected, may still be clinically diagnosed or LTBI/Non-TB
      finalDiagnosis = 'MTB Negative (Clinical review needed)';
    }

    // Update the patient object
    patient.diagnosisStatus = finalDiagnosis;

    // Navigate to the follow-up page for treatment initiation
    Navigator.of(context).pushReplacementNamed('/followup', arguments: patient);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the patient object passed from the screening page
    final patient = ModalRoute.of(context)!.settings.arguments as Patient;
    final screeningData =
        patient.screening; // Access the captured screening data

    return Scaffold(
      appBar: AppBar(title: Text('Diagnosis & Lab Results: ${patient.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: Symptom Review (from Screening Page) ---
            _buildSectionHeader(
              '1. Clinical Symptom Review (Presumptive Case) 📋',
            ),

            // Display the specific symptoms recorded in ScreeningData
            _buildSymptomCheckItem(
              _tbSymptoms[0],
              screeningData.coughDurationWeeks >= 2,
            ),
            _buildSymptomCheckItem(_tbSymptoms[2], screeningData.hasWeightLoss),
            _buildSymptomCheckItem(_tbSymptoms[4], screeningData.hasFever),

            // Note: Haemoptysis, Night sweats, Fatigue, and Chest pain
            // would need dedicated fields on the Screening page to be accurate here.
            // For now, these are placeholder flags, assuming they were part of
            // the 'other symptoms' on the original screening form.
            _buildSymptomCheckItem(_tbSymptoms[1], false), // Placeholder
            _buildSymptomCheckItem(_tbSymptoms[3], true), // Placeholder
            _buildSymptomCheckItem(_tbSymptoms[5], true), // Placeholder
            _buildSymptomCheckItem(_tbSymptoms[6], false), // Placeholder

            const Divider(height: 30),

            // --- SECTION 2: Diagnostic Test Results Input ---
            _buildSectionHeader('2. Lab Results Input (GeneXpert/NAAT) 🔬'),

            // GeneXpert Result
            const Text(
              'A. MTB Detection Result:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('MTB Detected'),
              value: 'MTB Detected',
              // ignore: deprecated_member_use
              groupValue: _geneXpertResult,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _geneXpertResult = value),
            ),
            RadioListTile<String>(
              title: const Text('MTB Not Detected'),
              value: 'MTB Not Detected',
              // ignore: deprecated_member_use
              groupValue: _geneXpertResult,
              // ignore: deprecated_member_use
              onChanged: (value) {
                setState(() {
                  _geneXpertResult = value;
                  _resistanceStatus =
                      null; // Reset resistance if MTB not detected
                });
              },
            ),

            const SizedBox(height: 20),

            // Resistance Status (Only if MTB is Detected)
            if (_geneXpertResult == 'MTB Detected')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'B. Rifampicin Resistance Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(
                    title: const Text('Rifampicin Susceptible'),
                    value: 'Rifampicin Susceptible',
                    // ignore: deprecated_member_use
                    groupValue: _resistanceStatus,
                    // ignore: deprecated_member_use
                    onChanged: (value) =>
                        setState(() => _resistanceStatus = value),
                  ),
                  RadioListTile<String>(
                    title: const Text('Rifampicin Resistant'),
                    value: 'Rifampicin Resistant',
                    // ignore: deprecated_member_use
                    groupValue: _resistanceStatus,
                    // ignore: deprecated_member_use
                    onChanged: (value) =>
                        setState(() => _resistanceStatus = value),
                  ),
                ],
              ),

            const SizedBox(height: 40),

            // --- Finalize Button ---
            ElevatedButton.icon(
              icon: const Icon(Icons.verified_user),
              label: const Text('Finalize Diagnosis and Plan Treatment'),
              onPressed: () => _confirmDiagnosis(context, patient),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Widget Builders ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(255, 0, 100, 150),
        ),
      ),
    );
  }

  Widget _buildSymptomCheckItem(String symptom, bool isPresent) {
    return ListTile(
      leading: Icon(
        isPresent ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isPresent ? Colors.green : Colors.grey,
      ),
      title: Text(
        symptom,
        style: TextStyle(
          fontWeight: isPresent ? FontWeight.bold : FontWeight.normal,
          color: isPresent ? Colors.black : Colors.grey[700],
        ),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}

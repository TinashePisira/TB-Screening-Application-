// lib/followup_page.dart

import 'package:flutter/material.dart';
import 'data_models.dart'; // Ensure Patient and ScreeningData are available

// --- 1. Follow-Up Visit Data Model ---
class FollowUpVisit {
  final DateTime visitDate;
  final int treatmentMonth;
  final String treatmentPhase; // Intensive Phase / Continuation Phase
  final String treatmentSupporterName;

  FollowUpVisit({
    required this.visitDate,
    required this.treatmentMonth,
    required this.treatmentPhase,
    required this.treatmentSupporterName,
  });
}

// --- 2. FollowUpPage Widget ---
class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  // Mock list to store recorded visits for this specific patient
  final List<FollowUpVisit> _visitHistory = [];

  // Form variables for the Modal
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedVisitDate;
  int? _selectedTreatmentMonth;
  String _treatmentSupporterName = '';

  // Helper function to determine the phase based on month (standard 6-month regimen 2RHZE/4RH)
  String _determinePhase(int month) {
    if (month >= 1 && month <= 2) {
      return 'Intensive Phase';
    } else if (month >= 3 && month <= 6) {
      return 'Continuation Phase';
    } else {
      return 'Extended Treatment / Post-Treatment';
    }
  }

  // --- Date Picker Function ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023), // Allow back-dating visits slightly
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedVisitDate) {
      setState(() {
        _selectedVisitDate = picked;
      });
    }
  }

  // --- Record Visit Logic ---
  void _recordNewVisit() {
    // Ensure that the StateSetter inside the modal has updated the main state variables
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedVisitDate == null || _selectedTreatmentMonth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both Visit Date and Treatment Month.'),
          ),
        );
        return;
      }

      final newVisit = FollowUpVisit(
        visitDate: _selectedVisitDate!,
        treatmentMonth: _selectedTreatmentMonth!,
        treatmentPhase: _determinePhase(_selectedTreatmentMonth!),
        treatmentSupporterName: _treatmentSupporterName,
      );

      setState(() {
        _visitHistory.add(newVisit);
        // Reset form variables (optional, as the modal will close anyway)
        _selectedVisitDate = null;
        _selectedTreatmentMonth = null;
        _treatmentSupporterName = '';
      });
      Navigator.of(context).pop(); // Close the bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New follow-up visit recorded successfully.'),
        ),
      );
    }
  }

  // --- UI: Modal Form to Add New Visit ---
  void _showAddVisitForm() {
    // Reset state before showing the form to ensure a clean slate
    _selectedVisitDate = null;
    _selectedTreatmentMonth = null;
    _treatmentSupporterName = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows keyboard to push content up
      builder: (BuildContext context) {
        // Use StatefulBuilder to manage the state inside the modal (e.g., phase update)
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    20, // Adjust bottom padding for keyboard
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Record New Follow-up Visit',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Divider(),

                    // 1. Visit Date Input
                    ListTile(
                      title: const Text('Visit Date (Required)'),
                      subtitle: Text(
                        _selectedVisitDate == null
                            ? 'Tap to select date'
                            : '${_selectedVisitDate!.day}/${_selectedVisitDate!.month}/${_selectedVisitDate!.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        await _selectDate(context);
                        modalSetState(
                          () {},
                        ); // Update the state of the modal bottom sheet
                      },
                    ),

                    // 2. Month of Treatment Input
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Month of Treatment (Required)',
                      ),
                      initialValue: _selectedTreatmentMonth,
                      items: List.generate(12, (index) => index + 1).map((
                        int month,
                      ) {
                        return DropdownMenuItem<int>(
                          value: month,
                          child: Text('Month $month'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        modalSetState(() {
                          _selectedTreatmentMonth = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Month is required' : null,
                      onSaved: (value) => _selectedTreatmentMonth = value,
                    ),

                    const SizedBox(height: 10),

                    // 3. Phase Display (Derived from Month)
                    if (_selectedTreatmentMonth != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Phase: **${_determinePhase(_selectedTreatmentMonth!)}**',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 16,
                          ),
                        ),
                      ),

                    // 4. Treatment Supporter Name Input
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Treatment Supporter Name',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Supporter Name is required' : null,
                      onSaved: (value) => _treatmentSupporterName = value!,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _recordNewVisit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Record Visit'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 3. Main Widget Build Method ---
  @override
  Widget build(BuildContext context) {
    // Retrieve the patient object
    final patient = ModalRoute.of(context)!.settings.arguments as Patient;

    return Scaffold(
      appBar: AppBar(title: Text('Follow-up: ${patient.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Patient Summary Card ---
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnosis: **${patient.diagnosisStatus}**',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Regimen: **${patient.treatmentRegimen}**',
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- Visit History Section Header and Button ---
            const Text(
              'Follow-up Visit History (DOT Log) 📅',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // --- Display Visit History ---
            Expanded(
              child: _visitHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No follow-up visits recorded yet.'),
                          const SizedBox(height: 10),

                          // Display a flow chart to explain the treatment process
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Record First Visit'),
                            onPressed: _showAddVisitForm,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _visitHistory.length,
                      itemBuilder: (context, index) {
                        final visit = _visitHistory.reversed
                            .toList()[index]; // Show most recent first
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  visit.treatmentPhase.contains('Intensive')
                                  ? Colors.red.shade100
                                  : Colors.blue.shade100,
                              child: Text(
                                'M${visit.treatmentMonth}',
                                style: TextStyle(
                                  color:
                                      visit.treatmentPhase.contains('Intensive')
                                      ? Colors.red.shade800
                                      : Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              'Visit Date: **${visit.visitDate.day}/${visit.visitDate.month}/${visit.visitDate.year}**',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Phase: **${visit.treatmentPhase}**\nSupporter: ${visit.treatmentSupporterName}',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Floating button to easily trigger the form
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVisitForm,
        label: const Text('Record New Visit'),
        icon: const Icon(Icons.medical_services),
      ),
    );
  }
}

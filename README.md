Here is a structure and content for the TB-Connect application, covering setup, features and design decisions.
________________________________________
 TB-Connect: Tuberculosis Management System (Flutter)
TB-Connect is a cross-platform mobile application designed for healthcare workers (HCWs) to streamline the process of Tuberculosis (TB) screening, diagnosis, treatment management (including Directly Observed Therapy - DOT), and patient follow-up. Built using Flutter, it aims to improve data accuracy and treatment adherence in community health settings, especially where connectivity is limited.
________________________________________
 1. Setup Instructions
These instructions will get a copy of the project up and running on your local machine for development and testing.
Prerequisites
•	Flutter SDK: Ensure you have the latest stable version of Flutter installed.
o	Verify installation by running: flutter doctor
•	Dart: (Comes bundled with Flutter).
•	IDE: Visual Studio Code or Android Studio with the Flutter and Dart extensions installed.
Installation Steps
1.	Clone the Repository:
Bash
git clone [YOUR-REPO-URL-HERE]
cd tb_connect
2.	Get Dependencies:
Bash
flutter pub get
3.	Run the Application:
Ensure you have an active emulator, simulator, or a connected physical device.
Bash
flutter run
(Note: For the full application functionality, a Firebase/Backend connection would need to be configured, including setting up google-services.json or GoogleService-Info.plist.)
________________________________________
2. Project Features
TB-Connect covers the entire continuum of TB care, from initial contact to treatment completion.
Core Modules
•	Login Module (/): Secure role-based login for Healthcare Workers (HCWs) using username and password (to be backed by a secure authentication service like Firebase Auth).
•	Patient Registration (/register): Detailed intake form capturing essential demographic and historical data.
o	Variables: Full Name, Date of Birth, National ID/Passport, Contact details, Next of Kin, Past Medical/Surgical/Family History, and Immunization Status.
•	TB Screening (/screening): Guided symptom questionnaire.
o	Logic: Automatic flagging of a Presumptive TB Case based on key symptoms (e.g., cough $\geq 2$ weeks, fever, weight loss).
•	TB Diagnosis (/diagnosis): Symptom review and input module for laboratory results.
o	Inputs: GeneXpert/NAAT result (MTB Detected/Not Detected) and Rifampicin Resistance status.
o	Output: Final diagnosis status (e.g., Confirmed Active TB, DR-TB).
•	Patient Follow-up (/followup): Treatment monitoring and adherence tracking.
o	Visit Tracking: HCWs record follow-up details including Visit Date, Month of Treatment, Treatment Phase (Intensive/Continuation), and Treatment Supporter Name.
o	History Log: Displays a chronological log of all recorded follow-up visits.
________________________________________
3. Design and Technical Notes
Design Principles
Component	Rationale
Cross-Platform (Flutter)	Allows deployment to both Android and iOS from a single codebase, crucial for maximizing reach in public health programs.
Data Integrity	Extensive use of the GlobalKey<FormState> and validators on all input fields to ensure data quality and completeness before submission.
User Experience (UX)	Clear separation of modules via routes and use of common UI patterns (Cards, Radio buttons, Date Pickers) to minimize training time for HCWs.
Responsiveness	Use of SingleChildScrollView on all long forms (Registration, Screening, Diagnosis) to ensure accessibility and prevent scroll issues across different screen sizes (mobile, tablet, and web).
Technical Architecture Notes
•	State Management: The current structure relies on passing data between screens using route arguments (e.g., passing the Patient object from Registration to Screening). For a larger application, consider upgrading to a robust state management solution like Riverpod or Bloc.
•	Data Models: Data is encapsulated in strongly typed Dart classes (Patient, ScreeningData, FollowUpVisit) located in lib/data_models.dart.
•	Offline Capability: For real-world deployment, the app must integrate a persistent local storage solution (e.g., sqflite or Hive) to enable HCWs to record data offline and synchronize later when connectivity is available.
•	Security: Placeholder for secure backend integration (API/Cloud Firestore) must enforce role-based access control (RBAC) and encrypt all sensitive Protected Health Information (PHI) both in transit and at rest.


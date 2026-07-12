# 🛡️ Rakshak – Women Safety Mobile Application

Rakshak is a Flutter-based women's safety mobile application designed to provide quick emergency assistance and improve personal security. The application enables users to send SOS alerts, share their live location with trusted contacts, and access emergency services with a single tap.

The project focuses on leveraging modern mobile technologies to deliver a fast, reliable, and user-friendly safety solution.

---

## ✨ Features

- 🚨 One-Tap SOS Alert
- 📍 Live Location Sharing
- 👨‍👩‍👧 Trusted Emergency Contacts
- 📞 Emergency Calling
- 💬 Emergency SMS Alerts
- 🗺️ Google Maps Integration
- 🔐 Firebase Authentication
- ☁️ Cloud Firestore Database
- 🔔 Real-Time Notifications
- 📱 Clean and Responsive User Interface

---

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart

### Backend
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Messaging (Optional)

### APIs
- Google Maps API
- SMS API
- Phone Call Integration
- Geolocation Services

---

## 📂 Project Structure

```
lib/
│
├── models/
├── screens/
├── services/
├── widgets/
├── utils/
├── providers/
├── firebase_options.dart
└── main.dart

assets/
    ├── images/
    └── icons/

android/
ios/
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or VS Code
- Firebase Project
- Google Maps API Key

---

### Installation

Clone the repository

```bash
git clone https://github.com/your-username/rakshak.git
```

Navigate to the project directory

```bash
cd rakshak
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

## 🔥 Firebase Setup

1. Create a Firebase project.
2. Enable Firebase Authentication.
3. Enable Cloud Firestore.
4. Download the Firebase configuration file.
5. Place:
   - `google-services.json` inside `android/app`
   - `GoogleService-Info.plist` inside `ios/Runner`
6. Configure Firebase in the Flutter project.

---

## 🗺️ Google Maps Setup

1. Create a Google Cloud project.
2. Enable the Maps SDK.
3. Generate an API key.
4. Add the API key to:
   - Android Manifest
   - iOS AppDelegate or Info.plist

---

## 📱 Application Workflow

1. User registers or logs in.
2. User adds trusted emergency contacts.
3. During an emergency:
   - Press the SOS button.
   - Current location is fetched.
   - SMS alerts are sent.
   - An emergency call can be initiated.
   - Live location is shared with trusted contacts.
4. Emergency contacts receive the user's location and can provide immediate assistance.

---

## 📦 Dependencies

Some commonly used packages include:

- firebase_core
- firebase_auth
- cloud_firestore
- google_maps_flutter
- geolocator
- geocoding
- url_launcher
- permission_handler
- flutter_sms
- provider

---

## 🔒 Security

- Secure user authentication using Firebase Authentication.
- Firestore Security Rules protect user data.
- Runtime permission handling for location and phone access.
- Sensitive credentials are excluded using `.gitignore`.

---

## 📌 Future Enhancements

- Voice-Activated SOS
- Shake Detection
- Fake Call Feature
- Offline Emergency Mode
- AI-Based Risk Prediction
- Emergency Audio Recording
- Emergency Video Recording
- Wearable Device Integration
- Nearby Police Station and Hospital Locator
- Safe Route Recommendation
- Multi-Language Support

---

## 🤝 Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License.

---

## 👩‍💻 Developer

**Hinal Patel**

Computer Science Engineering Student

Flutter Developer | Data Analytics Enthusiast

---

## ⭐ Support

If you found this project helpful, please consider giving it a ⭐ on GitHub.

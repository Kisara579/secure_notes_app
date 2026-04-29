# 🔐 Safe Notes

A secure note-taking mobile application built using Flutter.
This app demonstrates basic cybersecurity concepts such as user authentication and protected local data storage.

---

## 📱 Features

- 🔒 PIN-based authentication (first-time setup + login)
- 📝 Create and delete notes
- 💾 Persistent storage using local device memory
- 🔐 Encoded note storage (Base64)
- 🎨 Clean and modern UI design

---

## 🛠️ Technologies Used

- **Flutter (Dart)**
- **SharedPreferences** (local storage)
- **Material UI**

---

## 🔐 Security Implementation

- User authentication using a PIN
- Notes are encoded before storage (Base64 encoding)
- Data stored locally on the device

---

## ⚠️ Limitations

- Notes are encoded, not fully encrypted
- SharedPreferences is not a secure storage solution
- No biometric authentication yet

---

## 🚀 Future Improvements

- 🔐 AES encryption for stronger data protection
- 👆 Fingerprint / Face unlock
- ☁️ Cloud backup and sync
- 🗂️ Note categories and search

---

## 📸 Screenshots

(Add your app screenshots here)

---

## 📦 Installation

```bash
git clone https://github.com/your-username/secure_note_app.git
cd secure_note_app
flutter pub get
flutter run
```

---

## 🎯 Project Purpose

This project was developed to learn:

- Flutter app development
- State management using StatefulWidget
- Local data storage techniques
- Basic cybersecurity concepts in mobile apps

---

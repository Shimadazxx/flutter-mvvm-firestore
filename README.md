# 🚀 Flutter MVVM Firestore Tasks Application

Aplikasi sederhana untuk manajemen tugas (*Task Management*) yang dibangun menggunakan **Flutter**, **Firebase Cloud Firestore**, dan menerapkan arsitektur **MVVM (Model-View-ViewModel)** dengan **Provider** sebagai *state management*.

## 🏗️ Struktur Arsitektur Project

Proyek ini dibuat dengan menerapkan pemisahan kode (*separation of concerns*) agar lebih terstruktur dan *maintainable*:

```text
lib/
 ├── models/          # Layer Model: Menangani representasi data (Task)
 ├── viewmodels/      # Layer ViewModel: Logika bisnis & integrasi Cloud Firestore
 ├── views/           # Layer View: Antarmuka pengguna (UI) murni
 ├── firebase_options.dart # Konfigurasi Firebase
 └── main.dart        # Entry point & inisialisasi Provider

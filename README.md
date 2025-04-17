# 📲 Aplikasi CRUD Alamat – Flutter + REST API

Aplikasi ini merupakan implementasi dari sistem **CRUD Alamat** menggunakan Flutter, terhubung dengan **REST API Blueray Cargo**.  
User dapat melakukan **login, registrasi, mengatur alamat, upload NPWP**, serta menggunakan **OpenStreetMap untuk pemilihan lokasi.**

---

## ✨ Fitur Aplikasi

### 1. Autentikasi
- **Login**: User dapat login menggunakan email & password.
- **Register**:
  - Tahap 1: Kirim kode verifikasi ke email
  - Tahap 2: Verifikasi kode
  - Tahap 3: Isi data nama, nomor HP, password

### 2. CRUD Alamat
- **Create**: Tambah alamat dengan data lengkap
- **Read**: Menampilkan daftar alamat user
- **Update**: Edit alamat yang sudah tersimpan
- **Delete**: Hapus alamat dari sistem

### 3. Set Default Address ⭐
- User bisa memilih salah satu alamat sebagai **alamat utama**
- Alamat default ditandai dengan ikon ⭐ warna kuning

### 4. Upload NPWP
- User bisa upload file gambar NPWP
- File dikirim ke API dan disimpan sebagai URL

### 5. Lokasi dari Peta (OpenStreetMap)
- User bisa memilih titik lokasi menggunakan **OpenStreetMap**
- Hasil koordinat dan alamat akan terisi otomatis

### 6. Dropdown Lokasi
- Provinsi, Kota/Kabupaten, dan Kecamatan diambil dari API
- Dropdown bersifat dinamis: berubah sesuai pilihan sebelumnya

---

## 🛠 Teknologi yang Digunakan

- **Flutter** (null safety)
- **StatefulWidget + Form**
- **OpenStreetMap** via `flutter_map`
- **HTTP Request** dengan package `http`
- **File Upload** dengan `image_picker`
- **SharedPreferences** untuk token login
- **API Base**: `https://devuat.blueraycargo.id`

---

## 🚀 Cara Menjalankan Aplikasi

1. Clone repo ini
2. Jalankan perintah:
```bash
flutter pub get
flutter run
```

> Pastikan emulator atau device sudah aktif

---

## 📦 Struktur Folder

```
lib/
├── models/             # Model data (Address)
├── screens/
│   ├── auth/           # Login & Register screen
│   ├── address/        # CRUD alamat + map picker
│   └── home_screen.dart
├── services/           # File auth_service.dart dan address_service.dart
└── main.dart
```

---

## 🔐 Catatan Keamanan
Token akses dari API disimpan di `SharedPreferences`. Disarankan untuk menggunakan metode penyimpanan yang lebih aman seperti `flutter_secure_storage` di produksi.
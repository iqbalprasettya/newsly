# Newsly - Aplikasi Beritaa

Aplikasi pembaca berita modern dan lengkap yang dibangun dengan Flutter, didukung oleh [NewsAPI.org](https://newsapi.org/). Nikmati berita terbaru dengan antarmuka yang indah, intuitif, dan fitur-fitur canggihhhh.

## Fitur Utama

### Fitur Inti

- **Slider Berita Terkini** - Carousel horizontal dengan berita utama
- **Pencarian Cerdas** - Pencarian real-time di semua artikel
- **Filter Kategori** - Jelajahi berita berdasarkan kategori (Bisnis, Teknologi, Olahraga, dll.)
- **Tampilan Detail Artikel** - Konten lengkap dengan format yang kaya
- **Simpan Artikel** - Bookmark artikel untuk dibaca offline
- **Profil Pengguna** - Pengalaman personal dengan profil yang dibuat otomatis

### Fitur UI/UX

- **Desain Modern** - Antarmuka bersih berbasis kartu dengan tema orange
- **Mode Gelap** - Beralih antara tema terang dan gelap
- **AppBar Terintegrasi** - Desain header yang mulus di semua layar
- **Animasi Halus** - Efek fade-in dan transisi yang smooth
- **Loading Shimmer** - State loading yang indah
- **Layout Responsif** - Dioptimalkan untuk semua ukuran layar

### Fitur Teknis

- **Arsitektur Bersih** - Struktur kode terorganisir dengan pemisahan concern
- **Manajemen State** - Pattern Provider untuk penanganan state yang efisien
- **Penyimpanan Lokal** - Database Hive untuk penyimpanan artikel offline
- **Cache Gambar** - Loading dan caching gambar yang dioptimalkan
- **Penanganan Error** - State error yang komprehensif dan feedback pengguna
- **URL Launcher** - Integrasi browser yang ditingkatkan dengan opsi fallback

## Instalasi

1. **Clone repository ini**

   ```bash
   git clone <repository-url>
   cd newsly
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Dapatkan API key dari [NewsAPI.org](https://newsapi.org/)**

   - Daftar akun gratis
   - Salin API key Anda
   - Tier gratis memungkinkan 1000 request per hari

4. **Update API key**

   Ganti API key di file `APIKey.txt`:

   ```
   YOUR_API_KEY_HERE
   ```

5. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## Teknologi yang Digunakan

### Framework Utama

- **Flutter** - Framework UI cross-platform
- **Dart** - Bahasa pemrograman

### Manajemen State & Arsitektur

- **Provider** - Solusi manajemen state
- **Clean Architecture** - Struktur kode yang terorganisir

### Data & Penyimpanan

- **HTTP** - Komunikasi API
- **Hive** - Database lokal untuk penyimpanan offline
- **SharedPreferences** - Penyimpanan pengaturan dan preferensi

### UI & UX

- **Material Design 3** - Komponen UI modern
- **CachedNetworkImage** - Loading gambar yang dioptimalkan
- **Shimmer** - Animasi loading yang indah
- **URL Launcher** - Integrasi browser yang ditingkatkan

### Utilitas

- **Intl** - Internasionalisasi dan format tanggal
- **Provider** - Dependency injection dan manajemen state

## Struktur Proyek

```
lib/
├── main.dart                    # Titik masuk aplikasi
├── config/
│   ├── app_theme.dart          # Tema terang & gelap dengan skema warna orange
│   └── app_routes.dart         # Konfigurasi rute navigasi
├── models/
│   ├── article_model.dart      # Model data artikel dengan adapter Hive
│   ├── source_model.dart       # Model data sumber berita
│   └── user_profile.dart       # Model data profil pengguna
├── services/
│   ├── news_service.dart       # Layanan integrasi NewsAPI
│   ├── storage_service.dart    # Layanan penyimpanan SharedPreferences
│   ├── hive_service.dart       # Layanan database Hive
│   ├── storage_wrapper.dart    # Layer abstraksi penyimpanan
│   └── profile_generator.dart  # Generator profil acak
├── providers/
│   ├── news_provider.dart      # Manajemen state data berita
│   ├── theme_provider.dart     # Manajemen state tema
│   └── saved_articles_provider.dart # Manajemen state artikel tersimpan
├── screens/
│   ├── splash_screen.dart      # Layar loading aplikasi
│   ├── main_navigation.dart    # Wrapper navigasi bawah
│   ├── home_screen.dart        # Berita terkini & rekomendasi
│   ├── discover_screen.dart    # Pencarian & filter kategori
│   ├── saved_screen.dart       # Manajemen artikel tersimpan
│   ├── profile_screen.dart     # Profil pengguna & pengaturan
│   └── detail_screen.dart      # Tampilan detail artikel
├── widgets/
│   ├── news_card.dart          # Komponen kartu artikel
│   ├── modern_app_bar.dart     # Komponen app bar kustom
│   ├── breaking_news_slider.dart # Carousel berita horizontal
│   └── shimmer_loading.dart    # Komponen state loading
└── utils/
    └── error_widget.dart       # Komponen state error
```

## Fitur UI/UX

### Sistem Desain

- **Tema Orange**: Skema warna orange modern (#F25912) dengan Material Design 3
- **AppBar Terintegrasi**: Desain header yang mulus di semua layar
- **Layout Berbasis Kartu**: Komponen kartu yang bersih dan modern dengan bayangan halus
- **Desain Responsif**: Dioptimalkan untuk semua ukuran layar dan orientasi

### Pengalaman Pengguna

- **Navigasi Bawah**: Akses mudah ke semua fitur utama
- **Animasi Halus**: Efek fade-in, transisi slide, dan micro-interactions
- **Loading Shimmer**: State loading yang indah untuk performa yang lebih baik
- **Pull-to-Refresh**: Mekanisme refresh yang intuitif
- **Penanganan Error**: Pesan error yang user-friendly dengan opsi retry
- **Empty States**: Ilustrasi dan pesan state kosong yang membantu

### Aksesibilitas

- **Mode Gelap**: Beralih antara tema terang dan gelap dengan persistensi
- **Touch Targets**: Ukuran tombol dan target sentuh yang dioptimalkan
- **Tipografi**: Font yang jelas dan mudah dibaca dengan rasio kontras yang tepat
- **Feedback Visual**: Feedback visual yang jelas untuk semua interaksi

## Integrasi API

### Endpoint NewsAPI

- **Berita Utama**: `GET /v2/top-headlines?country=us&apiKey=YOUR_KEY`
- **Pencarian Artikel**: `GET /v2/everything?q={query}&apiKey=YOUR_KEY`
- **Artikel Berdasarkan Kategori**: `GET /v2/top-headlines?category={category}&apiKey=YOUR_KEY`
- **Sumber Berita**: `GET /v2/sources?apiKey=YOUR_KEY`

### Manajemen Data

- **Update Real-time**: Pengambilan data langsung dengan refresh otomatis
- **Dukungan Offline**: Penyimpanan lokal untuk artikel tersimpan dan preferensi pengguna
- **Cache Gambar**: Loading dan caching gambar yang dioptimalkan untuk performa yang lebih baik
- **Pemulihan Error**: Mekanisme retry otomatis dan opsi fallback

## Layar Aplikasi

### Layar Utama

- **Slider Berita Terkini**: Carousel horizontal menampilkan berita utama
- **Rekomendasi**: Artikel berita yang dikurasi di bawah slider
- **AppBar Terintegrasi**: Header bersih dengan toggle mode gelap

### Layar Penemuan

- **Pencarian Cerdas**: Pencarian real-time di semua artikel
- **Filter Kategori**: Jelajahi berita berdasarkan kategori dengan chip animasi
- **UI Modern**: Desain berbasis kartu dengan animasi halus

### Layar Tersimpan

- **Manajemen Artikel**: Lihat dan kelola artikel tersimpan
- **Swipe to Delete**: Gesture swipe yang intuitif untuk menghapus artikel
- **Aksi Massal**: Opsi hapus semua artikel tersimpan

### Layar Profil

- **Profil Pengguna**: Profil yang dibuat otomatis dengan informasi yang dapat diedit
- **Statistik**: Lihat jumlah artikel tersimpan
- **Pengaturan**: Toggle mode gelap dan preferensi

### Layar Detail

- **Tampilan Artikel Lengkap**: Konten artikel lengkap dengan format yang kaya
- **Fungsi Simpan**: Bookmark artikel untuk dibaca nanti
- **Link Eksternal**: Integrasi browser yang ditingkatkan dengan opsi fallback

## Memulai Pengembangan

Proyek ini mendemonstrasikan praktik pengembangan Flutter yang canggih:

### Arsitektur & Pattern

- **Clean Architecture**: Pemisahan concern dengan struktur folder yang terorganisir
- **Provider Pattern**: Manajemen state yang efisien di seluruh aplikasi
- **Repository Pattern**: Layer akses data yang diabstraksi
- **Service Layer**: Layanan API dan penyimpanan yang terpusat

### Fitur Flutter Modern

- **Material Design 3**: Implementasi sistem desain terbaru
- **Widget Kustom**: Komponen UI yang dapat digunakan kembali
- **Framework Animasi**: Transisi halus dan micro-interactions
- **Penyimpanan Lokal**: Integrasi database Hive untuk dukungan offline

### Best Practices

- **Penanganan Error**: State error yang komprehensif dan feedback pengguna
- **Optimasi Performa**: Cache gambar dan loading data yang efisien
- **Organisasi Kode**: Struktur kode yang modular dan mudah dipelihara
- **Pengalaman Pengguna**: Navigasi yang intuitif dan desain responsif

## Pengembangan

### Prasyarat

- Flutter SDK (3.0 atau lebih tinggi)
- Dart SDK (3.0 atau lebih tinggi)
- Android Studio / VS Code
- Akun NewsAPI dan API key

### Build untuk Produksi

```bash
# Build APK
flutter build apk --release

# Build App Bundle (direkomendasikan untuk Play Store)
flutter build appbundle --release

# Build untuk iOS
flutter build ios --release
```

### Dependencies Utama

```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.1          # Manajemen state
  http: ^1.1.0              # Panggilan API
  hive: ^2.2.3              # Database lokal
  hive_flutter: ^1.1.0      # Integrasi Hive Flutter
  cached_network_image: ^3.3.0  # Cache gambar
  url_launcher: ^6.2.2      # Link eksternal
  shimmer: ^3.0.0           # Animasi loading
  intl: ^0.19.0             # Format tanggal
  shared_preferences: ^2.2.2 # Penyimpanan pengaturan
```

## Deployment

### Android

1. Generate signed APK atau App Bundle
2. Upload ke Google Play Console
3. Konfigurasi metadata aplikasi dan screenshot

### iOS

1. Konfigurasi pengaturan proyek iOS
2. Build dan archive di Xcode
3. Upload ke App Store Connect

## Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file LICENSE untuk detail.

## Kontribusi

Kami menyambut kontribusi! Silakan ikuti langkah-langkah berikut:

1. **Fork repository ini**
2. **Buat feature branch**: `git checkout -b feature/nama-fitur-anda`
3. **Buat perubahan Anda** dan pastikan mengikuti style kode yang ada
4. **Test perubahan Anda** secara menyeluruh
5. **Commit perubahan Anda**: `git commit -m 'Tambahkan fitur Anda'`
6. **Push ke branch Anda**: `git push origin feature/nama-fitur-anda`
7. **Buka Pull Request** dengan deskripsi yang jelas tentang perubahan Anda

### Panduan Pengembangan

- Ikuti panduan style Flutter/Dart
- Tulis commit message yang bermakna
- Tambahkan test untuk fitur baru
- Update dokumentasi sesuai kebutuhan
- Pastikan semua test yang ada berhasil

## Dukungan & Feedback

- **Issues**: Laporkan bug atau minta fitur melalui GitHub Issues
- **Discussions**: Bergabung dalam diskusi komunitas untuk pertanyaan dan ide
- **Email**: Hubungi kami untuk dukungan langsung

## Roadmap

### Fitur yang Akan Datang

- [ ] Push notification untuk berita terkini
- [ ] Membaca artikel offline
- [ ] Fungsi berbagi artikel
- [ ] Dukungan multi bahasa
- [ ] Sumber berita kustom
- [ ] Bookmark artikel dengan tag
- [ ] Riwayat membaca dan analitik

### Peningkatan Performa

- [ ] Strategi caching yang canggih
- [ ] Optimasi gambar
- [ ] Lazy loading untuk daftar artikel besar
- [ ] Sinkronisasi background untuk artikel tersimpan

---

**Dibuat dengan Flutter**

_Proyek ini menampilkan praktik pengembangan Flutter modern dan berfungsi sebagai contoh komprehensif untuk membangun aplikasi berita yang siap produksi._

# Release Checklist

Pre-release steps yang harus dicek setiap kali membuat release build (AppBundle / IPA).
Ditambahkan dari production readiness audit 27 Jun 2026 (R-02, R-07).

---

## 1. Build Obfuscation

Setiap release build **harus** menggunakan flag berikut agar nama class/method
tidak terbaca dari binary hasil decompile:

```bash
# Android (App Bundle — Play Store)
flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info=./debug-info/android/ \
  --dart-define-from-file=.env

# iOS (Archive — App Store)
flutter build ipa \
  --release \
  --obfuscate \
  --split-debug-info=./debug-info/ios/ \
  --dart-define-from-file=.env
```

> **Jangan commit folder `debug-info/`** ke version control.
> Folder ini sudah ada di `.gitignore`. Symbol files-nya disimpan di Sentry
> via step berikutnya, bukan di repo.

---

## 2. Sentry Symbol Upload

Setelah setiap release build, upload debug symbols ke Sentry agar stack trace
di crash reports tetap readable meski binary sudah di-obfuscate.

```bash
# Install sentry-cli jika belum ada
npm install -g @sentry/cli
# atau: brew install getsentry/tools/sentry-cli

# Upload (Android)
sentry-cli upload-dif ./debug-info/android/ \
  --org <SENTRY_ORG_SLUG> \
  --project <SENTRY_PROJECT_SLUG>

# Upload (iOS)
sentry-cli upload-dif ./debug-info/ios/ \
  --org <SENTRY_ORG_SLUG> \
  --project <SENTRY_PROJECT_SLUG>
```

Atau gunakan script `scripts/upload_sentry_symbols.sh` yang sudah ada di repo
(set `SENTRY_ORG` dan `SENTRY_PROJECT` sebagai environment variable di CI).

> **Sentry auth token** untuk sentry-cli harus di-set sebagai CI secret:
> `SENTRY_AUTH_TOKEN=<token>` — jangan hardcode di script.

---

## 3. Android ProGuard

Verifikasi `android/app/build.gradle` release block:

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                      'proguard-rules.pro'
    }
}
```

`android/app/proguard-rules.pro` perlu minimal rules untuk plugin yang
menggunakan reflection:

```proguard
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# flutter_secure_storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Sentry
-keep class io.sentry.** { *; }
-dontwarn io.sentry.**

# Retrofit / Dio
-keep @retrofit2.http.* interface * { *; }
```

---

## 4. Environment Variables

Pastikan semua nilai di `.env` sudah diisi sebelum build:

```bash
BASE_URL=https://...
API_KEY=...
SENTRY_DSN=https://...@...ingest.sentry.io/...
```

> Lihat `.env.example` untuk template lengkap.
> Nilai SENTRY_DSN production ada di Sentry project settings → Client Keys.

---

## 5. Post-Build Verification

Setelah upload ke Play Store internal track / TestFlight:

- [ ] Buka app dari binary yang di-download (bukan debug build)
- [ ] Paksa crash kecil (atau gunakan `Sentry.captureException`) — verify event muncul di Sentry dengan stack trace readable (bukan obfuscated)
- [ ] Pastikan Sentry `environment` tag terbaca `prod`, bukan `dev`

---

_Checklist ini diupdate setiap kali ada perubahan pada build pipeline._
_Last updated: 27 Jun 2026_

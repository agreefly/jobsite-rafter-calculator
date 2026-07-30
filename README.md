# Job-Site Rafter Calculator

A high-contrast Flutter app for mobile framing layout, rafter length, cut list, and materials estimation.

## Project Setup

1. Install Flutter and ensure `flutter doctor` passes.
2. If platform folders are not generated, run:
   ```bash
   flutter create .
   ```
3. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```

## What it includes

- Rafter length calculator with ridge thickness adjustment
- Cut list output for total rafter length and overhang
- Roof pitch summary
- Light materials quantity estimate
- High-contrast mobile-ready UI skeleton

## Publishing

### Android

- Run `flutter build apk`
- Follow Google Play publishing guides for signing and upload

### Apple

- Run `flutter build ipa`
- Use Xcode or App Store Connect to distribute

## GitHub

This repository is ready to be published as a public GitHub project. Use `gh repo create` if desired.

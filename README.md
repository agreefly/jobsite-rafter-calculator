# Job-Site Rafter Calculator

A high-contrast Flutter app for mobile framing layout, rafter length, cut list, and materials estimation.

## Project Setup

1. Install Flutter and ensure `flutter doctor` passes.
2. If platform folders are not generated, run:
   ```bash
   flutter create .
   ```
3. Set the production identifiers if you plan to publish:
   - Android `applicationId`: `com.agreefly.jobsite_rafter_calculator`
   - iOS bundle identifier: `com.agreefly.jobsite_rafter_calculator`
4. From the project root:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   flutter run
   ```

## App icons

- A high-contrast app icon placeholder is included at `assets/icon/app_icon.png`.
- Run the launcher icon generator after `flutter pub get`.

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

## Release Guide

For store-specific packaging and signing steps, see `RELEASE.md`.

For Android signing template and Apple/Xcode signing checklist, see `SIGNING.md`.

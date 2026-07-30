# Release Checklist for Job-Site Rafter Calculator

This file describes the exact steps and metadata needed to publish the app to Google Play and the Apple App Store.

## 1. Prepare the Flutter project

1. Run:
   ```bash
   flutter create .
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```
2. Verify the app launches on a simulator or device:
   ```bash
   flutter run
   ```
3. Confirm the app package name and bundle identifier:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner.xcodeproj` / `ios/Runner/Info.plist`

## 2. Set app identifiers and versioning

Use these recommended production identifiers:

- Android applicationId: `com.agreefly.jobsite_rafter_calculator`
- iOS bundle identifier: `com.agreefly.jobsite_rafter_calculator`

### Android

- Open `android/app/build.gradle`
- Set `applicationId` to your package name, for example:
  ```groovy
  defaultConfig {
      applicationId "com.agreefly.jobsite_rafter_calculator"
      minSdkVersion 21
      targetSdkVersion 34
      versionCode 1
      versionName "0.1.0"
  }
  ```

### iOS

- Open `ios/Runner.xcworkspace` in Xcode.
- Set the bundle identifier to the production value:
  `com.agreefly.jobsite_rafter_calculator`
- Set the build version and release version under Runner > General.

## 3. Add required assets

### Icons

- Confirm launcher icon files are generated.
- Replace the placeholder icon in `assets/icon/app_icon.png` with a production-ready icon.

### Screenshots

- Android: 1080 x 1920 or similar vertical screenshots
- iOS: 1242 x 2688 or equivalent device-specific screenshot sizes

### Store listing images

- Add a simple app preview banner for Play Store if available.

## 4. Google Play release

### Create or use a Google Play Console account

- Sign in to Google Play Console
- Create a new app using:
  - App name
  - Default language
  - App type: `Application`
  - Free or paid

### App signing

- Generate a signing key if you do not have one:
  ```bash
  keytool -genkey -v -keystore ~/release-key.jks -alias release-key -keyalg RSA -keysize 2048 -validity 10000
  ```
- Add the key to `android/key.properties`:
  ```properties
  storePassword=YOUR_STORE_PASSWORD
  keyPassword=YOUR_KEY_PASSWORD
  keyAlias=release-key
  storeFile=/Users/you/release-key.jks
  ```
- Update `android/app/build.gradle` to load `key.properties`.

### Build the signed APK/AAB

- Preferred: Android App Bundle
  ```bash
  flutter build appbundle --release
  ```
- If APK is needed:
  ```bash
  flutter build apk --release
  ```

### Upload and metadata

Upload to the Play Console and complete:
- App description
- Short description
- Screenshots for phone
- App category and contact info
- Privacy policy URL
- Content rating questionnaire
- Pricing and distribution

## 5. Apple App Store release

### Create or use an Apple Developer account

- Sign in to Apple Developer and App Store Connect
- Create a new App record in App Store Connect
- Use the same bundle identifier configured in Xcode

### Certificates and provisioning

- In Xcode, enable automatic signing or configure manual signing.
- Ensure your Apple ID is connected to Xcode.
- Select a development team and let Xcode manage provisioning profiles.

### Build an IPA

- For a simulator build, use `flutter run`.
- For App Store distribution:
  ```bash
  flutter build ipa --release
  ```
- Alternatively, archive from Xcode and export for App Store.

### Upload to App Store Connect

- Use Xcode Organizer or `Transporter` to upload the IPA.
- In App Store Connect, complete:
  - App name
  - Subtitle
  - Description
  - Keywords
  - Support URL
  - Marketing URL
  - Privacy policy URL
  - Screenshots for all required device sizes
  - App icon and promotional images

## 6. General metadata recommendations

- App name: `Job-Site Rafter Calculator`
- Short description: `Quick field-ready rafter layout and materials estimate.`
- Full description:
  > High-contrast job-site calculator for rafters, cut lists, and material estimates. Designed for fast input, offline use, and construction conditions.
- Privacy policy: Provide a simple URL or placeholder once hosting is available.
- Contact email: a real support address for store listing.

## 7. Release testing

- Test on Android physical device and iOS device if available.
- Confirm the high-contrast UI works outdoors.
- Verify numeric input behavior and output formatting.

## 8. After release

- Monitor crash reports and user feedback.
- Update versionCode/versionName and build numbers before each store submission.
- Keep UI input large and gloved-friendly in future updates.

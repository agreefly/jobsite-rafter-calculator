# Signing and Release Checklist

## Android: `key.properties` template

Create a file at `android/key.properties` with your signing key values.

Example contents:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=release-key
storeFile=/Users/you/release-key.jks
```

### Configure `android/app/build.gradle`

Add the following to the `android` block if not already present:

```groovy
def keystorePropertiesFile = rootProject.file('key.properties')
def keystoreProperties = new Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystorePropertiesFile.exists() ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Generate a signing key

Use `keytool` if you need a new key:

```bash
keytool -genkey -v -keystore ~/release-key.jks -alias release-key -keyalg RSA -keysize 2048 -validity 10000
```

Keep the resulting `release-key.jks` file secure and back it up.

## Apple / Xcode signing checklist

### Bundle ID

- Open `ios/Runner.xcworkspace` in Xcode.
- In Runner > Signing & Capabilities, set the bundle identifier to a unique value, for example:
  `com.agreefly.jobsite-rafter-calculator`

### Provisioning and certificates

- Use automatic signing if possible.
- Select your Apple Developer team.
- Let Xcode generate the provisioning profiles.
- If using manual signing, ensure the correct provisioning profile is selected for Release builds.

### Build settings

In Xcode, verify:
- `Deployment Target` matches your minimum supported iOS version
- `Build Configuration` is set to `Release` for App Store archive
- `Signing Certificate` is set to `Apple Distribution`

### Upload process

- Build the app archive: `Product > Archive`
- In the Organizer, select the archive and choose `Distribute App`
- Choose `App Store Connect` and follow the upload flow

## Notes

- Do not commit actual signing secrets to git.
- Keep `android/key.properties` private and excluded by `.gitignore`.
- Use unique app package IDs and bundle IDs for production.

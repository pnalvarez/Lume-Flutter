# Deploy setup (GitHub Actions)

Deploys **Lume** to:

- **Android** → [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- **iOS** → [TestFlight](https://developer.apple.com/testflight/)

Workflow file: `.github/workflows/deploy.yml`

Ensure `android/app/google-services.json` is committed — the Android release build requires it.

## Triggers

| Trigger | Behavior |
|---------|----------|
| Push tag `v*` (e.g. `v1.0.1`) | Deploy Android + iOS |
| Manual **workflow_dispatch** | Choose `both`, `android`, or `ios` |

Recommended release flow:

1. Merge to `main` (CI must pass)
2. Bump marketing version in `pubspec.yaml` when needed (`bump-version` skill or manual edit)
3. Commit, tag, and push:

```bash
git tag v1.0.1
git push origin main --tags
```

iOS **build numbers** (`CFBundleVersion`) are set automatically in CI: the workflow scans **all** App Store Connect builds for the app, takes the highest numeric version, and uses **max + 1** (Apple requires this number to rise across every marketing version). If upload still reports a duplicate, CI rebuilds and retries up to two more times with the next numbers. You do not need to bump the `+N` suffix in `pubspec.yaml` for TestFlight uploads.

## GitHub secrets

Add these in **Repository → Settings → Secrets and variables → Actions**.

### Android signing

| Secret | Description |
|--------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded release `.jks` / `.keystore` file |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_ALIAS` | Key alias (e.g. `upload`) |
| `ANDROID_KEY_PASSWORD` | Key password |

Generate base64 locally:

```bash
base64 -i upload-keystore.jks | pbcopy
```

Create a keystore if you don't have one:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

For local release builds, copy `android/key.properties.example` to `android/key.properties` and place the keystore at `android/app/upload-keystore.jks`.

### Firebase App Distribution

| Secret | Description |
|--------|-------------|
| `FIREBASE_TOKEN` | CI token from `firebase login:ci` |

Enable **App Distribution** in the [Firebase console](https://console.firebase.google.com/project/lume-51a38/appdistribution) and create a tester group named `internal` (or change `FIREBASE_TESTER_GROUPS` in the workflow).

CI uploads a release **APK** (not AAB) so Firebase works without linking a Google Play Developer account. Switch to AAB only when you publish on Play Store and link Firebase to Play.

Firebase Android app ID (already in workflow): `1:145151164143:android:2d2d7ec6d6ad0e73ca251a`

### iOS / TestFlight

| Secret | Description |
|--------|-------------|
| `IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64` | Base64-encoded **Apple Distribution** certificate exported as `.p12` |
| `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | Password used when exporting the `.p12` |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64-encoded **App Store Connect** `.mobileprovision` for `com.lume.learning.app` |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API key ID (10 chars) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from App Store Connect → Users and Access → Integrations |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | Full contents of the `.p8` API key file (include `BEGIN` / `END` lines) |

Create the API key in [App Store Connect](https://appstoreconnect.apple.com/access/integrations/api) with **App Manager** or **Admin** role.

Export the distribution certificate from Keychain Access → export as `.p12`, then:

```bash
base64 -i Certificates.p12 | pbcopy
```

Create an **App Store Connect** provisioning profile (Distribution — not Development) for App ID `com.lume.learning.app`, then:

```bash
base64 -i YourAppStore.mobileprovision | pbcopy
```

CI installs that profile and uses **manual** signing (team `L332B28T9P`) to build the IPA, then uploads with the App Store Connect API key.

## Cost notes

- Android builds run on `ubuntu-latest` (1× GitHub Actions minutes)
- iOS builds run on `macos-latest` (10× minutes on the free tier)
- Prefer **tag-triggered** deploys to conserve macOS minutes

## Troubleshooting

**Android: signing config not found** — verify `ANDROID_*` secrets and that `key.properties` paths match the workflow.

**Firebase: unauthorized** — regenerate token with `firebase login:ci` and update `FIREBASE_TOKEN`.

**Firebase: not linked to Google Play** — CI uses APK uploads to avoid this. If you switch back to AAB, link Play in Firebase → Project settings → Integrations.

**Android: keystore password was incorrect** — regenerate the keystore and update all four `ANDROID_*` secrets together.

**iOS: no signing certificate** — ensure the `.p12` contains an **Apple Distribution** cert (not Development).

**iOS: no provisioning profile / No Accounts** — use an **App Store Connect** profile (not Development), set `IOS_PROVISIONING_PROFILE_BASE64`, and confirm the profile includes your Distribution certificate.

**iOS: upload failed** — confirm the app record exists in App Store Connect for bundle ID `com.lume.learning.app`.

**Duplicate build number** — CI should auto-increment via App Store Connect (latest build + 1). If this still fails, confirm the API key can read builds for `com.lume.learning.app`.

# Deploy setup (GitHub Actions)

Deploys **Lume** to:

- **Android** → [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- **iOS** → [TestFlight](https://developer.apple.com/testflight/)
- **iOS App Store RC** → App Store Connect version (attach uploaded build; manual submit)
- **macOS** → [TestFlight](https://developer.apple.com/testflight/) (same App Store Connect app / bundle ID)
- **Web** → [Vercel](https://vercel.com) (`flutter build web` → production deploy)

Workflow file: `.github/workflows/deploy.yml`

Ensure `android/app/google-services.json` is committed — the Android release build requires it.

## Triggers

| Trigger | Behavior |
|---------|----------|
| Push tag `v*` (e.g. `v1.0.1`) | Deploy Android + iOS + macOS + Web |
| Manual **workflow_dispatch** | Toggle Android / iOS / **iOS App Store RC** / macOS / Web (macOS and RC default off) |

Recommended release flow:

1. Merge to `main` (CI must pass)
2. Bump marketing version in `pubspec.yaml` when needed (`bump-version` skill or manual edit)
3. Commit, tag, and push:

```bash
git tag v1.0.1
git push origin main --tags
```

### App Store release candidate (manual)

When you want a build attached to the iOS **App Store** version (not only TestFlight):

1. Bump / confirm the marketing version in `pubspec.yaml` (e.g. `1.0.1`)
2. Actions → **Deploy** → **Run workflow**
3. Enable **iOS → App Store version (upload + attach build as RC)** (optionally leave other platforms off)
4. Wait for **iOS → TestFlight** then **iOS → App Store RC** (RC polls until Apple finishes processing the build, up to ~45 minutes)
5. Open [App Store Connect](https://appstoreconnect.apple.com), finish metadata/screenshots if needed, then **Submit for Review**

The RC job creates the App Store version for the pubspec marketing version when missing, attaches the just-uploaded build, and sets export compliance (`usesNonExemptEncryption=false`) when unset. It does **not** submit for App Review.

If version `X.Y.Z` already exists in a non-editable state (e.g. Waiting for Review / Ready for Sale), bump the marketing version first.

iOS and macOS **build numbers** (`CFBundleVersion`) are set automatically in CI: the workflow scans **all** App Store Connect builds for the app (shared across iOS + macOS), takes the highest numeric version, and uses **max + 1**. If upload still reports a duplicate, CI rebuilds and retries up to two more times with the next numbers. You do not need to bump the `+N` suffix in `pubspec.yaml` for TestFlight uploads.

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

### macOS / TestFlight

Same App Store Connect app and bundle ID as iOS: `com.lume.learning.app` (macOS platform enabled on the app record).

| Secret | Description |
|--------|-------------|
| `MACOS_DISTRIBUTION_CERTIFICATE_P12_BASE64` | Base64-encoded **Apple Distribution** `.p12` |
| `MACOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | Password for that `.p12` |
| `MACOS_INSTALLER_CERTIFICATE_P12_BASE64` | Base64-encoded **3rd Party Mac Developer Installer** `.p12` (must not be Distribution) |
| `MACOS_INSTALLER_CERTIFICATE_PASSWORD` | Password for the installer `.p12` |
| `MACOS_PROVISIONING_PROFILE_BASE64` | Base64-encoded **Mac App Store** `.provisionprofile` for `com.lume.learning.app` |

Reuse the existing `APP_STORE_CONNECT_*` secrets for upload and build-number lookup.

Export **two separate** `.p12` files from Keychain Access → **My Certificates** (each with its private key):

1. `Apple Distribution: … (L332B28T9P)` → `macos-distribution.p12`
2. `3rd Party Mac Developer Installer: … (L332B28T9P)` → `macos-installer.p12`

```bash
base64 -i macos-distribution.p12 | pbcopy   # → MACOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
base64 -i macos-installer.p12 | pbcopy       # → MACOS_INSTALLER_CERTIFICATE_P12_BASE64
base64 -i Lume_Mac_App_Store.provisionprofile | pbcopy  # → MACOS_PROVISIONING_PROFILE_BASE64
```

Verify the installer file before uploading the secret:

```bash
openssl pkcs12 -in macos-installer.p12 -nokeys -passin pass:YOUR_PASSWORD \
  | openssl x509 -noout -subject
# subject must include "Installer"
```

CI imports **both** `.p12` files in a single custom keychain step (not two `import-codesign-certs` calls), builds with `flutter build macos --release`, packages a signed `.pkg` with `productbuild`, and uploads with `xcrun altool --type macos`.

`macos/Runner/Info.plist` must include `LSApplicationCategoryType` (currently `public.app-category.education`) or App Store Connect rejects the upload (error 90242).

Manual workflow runs leave the **macOS** checkbox off by default (macOS runners are expensive); enable it when you want a Mac TestFlight upload. Tag pushes still deploy macOS with the other platforms.

### Web / Vercel

| Secret | Description |
|--------|-------------|
| `VERCEL_TOKEN` | [Vercel → Account Settings → Tokens](https://vercel.com/account/tokens) (create a token with deploy access) |
| `VERCEL_ORG_ID` | Team / personal account ID from Project Settings → General → “Project ID” panel (`orgId` in `.vercel/project.json` after `vercel link`) |
| `VERCEL_PROJECT_ID` | Project ID from the same place (`projectId` in `.vercel/project.json`) |

One-time local setup (creates the Vercel project and prints the IDs):

```bash
npm i -g vercel
cd /path/to/lume
vercel link   # create or select the Flutter web project
cat .vercel/project.json   # copy orgId → VERCEL_ORG_ID, projectId → VERCEL_PROJECT_ID
```

Do **not** commit `.vercel/` (keep it gitignored). SPA routing is handled by `web/vercel.json` (copied into `build/web` by Flutter).

CI runs `flutter build web --release`, then `vercel deploy build/web --prod`. Tag pushes always include Web; manual runs include it when the **Web** checkbox is enabled.

Optional: override Supabase at build time with repository Variables / secrets and pass `--dart-define=SUPABASE_URL=…` / `SUPABASE_ANON_KEY=…` in the workflow (defaults in `AppConfig` match production today).

## Cost notes

- Android and Web builds run on `ubuntu-latest` (1× GitHub Actions minutes)
- iOS and macOS builds run on `macos-latest` (10× minutes on the free tier)
- Prefer **tag-triggered** deploys to conserve macOS minutes; leave the macOS checkbox off for most manual runs
- Vercel has its own [usage limits](https://vercel.com/docs/limits) for hosting

## Troubleshooting

**Android: signing config not found** — verify `ANDROID_*` secrets and that `key.properties` paths match the workflow.

**Firebase: unauthorized** — regenerate token with `firebase login:ci` and update `FIREBASE_TOKEN`.

**Firebase: not linked to Google Play** — CI uses APK uploads to avoid this. If you switch back to AAB, link Play in Firebase → Project settings → Integrations.

**Android: keystore password was incorrect** — regenerate the keystore and update all four `ANDROID_*` secrets together.

**iOS: no signing certificate** — ensure the `.p12` contains an **Apple Distribution** cert (not Development).

**iOS: no provisioning profile / No Accounts** — use an **App Store Connect** profile (not Development), set `IOS_PROVISIONING_PROFILE_BASE64`, and confirm the profile includes your Distribution certificate.

**iOS: upload failed** — confirm the app record exists in App Store Connect for bundle ID `com.lume.learning.app`.

**macOS: profile doesn’t include signing certificate** — recreate the Mac App Store profile with **Apple Distribution** (not only Mac App Distribution) selected.

**macOS: missing LSApplicationCategoryType (90242)** — ensure `macos/Runner/Info.plist` has `LSApplicationCategoryType`.

**macOS: no installer identity / Installer missing after import** — `MACOS_INSTALLER_CERTIFICATE_P12_BASE64` is probably still an Apple Distribution export. Re-export **3rd Party Mac Developer Installer** from Keychain, confirm `openssl … -subject` contains `Installer`, then update the secret. CI imports both certs in one step and fails early if Installer is missing.

**Duplicate build number** — CI should auto-increment via App Store Connect (max build + 1 across iOS + macOS, with retries). If this still fails, confirm the API key can read builds for `com.lume.learning.app`.

**App Store RC: version not editable** — bump `pubspec.yaml` marketing version, or cancel/finish the existing version in App Store Connect, then re-run with the RC checkbox.

**App Store RC: timed out waiting for VALID** — Apple is still processing the IPA; re-run only the RC path after the build shows as ready in App Store Connect, or re-run the full RC job (it uploads a new build).

**Vercel: Missing VERCEL_* secret** — add `VERCEL_TOKEN`, `VERCEL_ORG_ID`, and `VERCEL_PROJECT_ID` (see Web / Vercel above).

**Vercel: project not found / not linked** — run `vercel link` locally, then update `VERCEL_ORG_ID` / `VERCEL_PROJECT_ID` from `.vercel/project.json`.

**Web: blank page / routes 404** — confirm `web/vercel.json` is present so Flutter copies SPA rewrites into `build/web`.

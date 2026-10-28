# Release secrets (GitHub Actions)

Pushing a tag builds Android + iOS and uploads them (`.github/workflows/release.yml`):

```bash
git tag v1.0.0 && git push origin v1.0.0      # prod config  -> env/prod.json
git tag v1.0.0-staging && git push origin v1.0.0-staging   # staging config
```

Version name = tag, build number = workflow run number (so it always increases).
Android goes to the Google Play **internal** track, iOS to **TestFlight**.

Add these in GitHub: **Settings → Secrets and variables → Actions → New repository secret**.
The values never appear in this repository. Each command below copies one value to the
Windows clipboard (run it in Git Bash, then paste into GitHub). Nothing is printed.

Every command uses the full path, so no variable has to be set first.

## Android (Google Play)

| Secret | What it is |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | upload keystore, base64 |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `KEY_ALIAS` | `upload` |
| `KEY_PASSWORD` | key password |
| `PLAY_SERVICE_ACCOUNT_JSON` | Google Play service-account JSON (whole file) |

```bash
# ANDROID_KEYSTORE_BASE64
base64 -w0 /e/mostafa/Companies/Digital_Harbor/_keystores/sijilak/upload-keystore.jks | clip

# ANDROID_KEYSTORE_PASSWORD
grep '^storePassword=' /e/mostafa/Companies/Digital_Harbor/_keystores/sijilak/key.properties | cut -d= -f2- | tr -d '\r\n' | clip

# KEY_ALIAS
grep '^keyAlias=' /e/mostafa/Companies/Digital_Harbor/_keystores/sijilak/key.properties | cut -d= -f2- | tr -d '\r\n' | clip

# KEY_PASSWORD
grep '^keyPassword=' /e/mostafa/Companies/Digital_Harbor/_keystores/sijilak/key.properties | cut -d= -f2- | tr -d '\r\n' | clip

# PLAY_SERVICE_ACCOUNT_JSON  (existing saqqar-ci service account; see the Play Console notes below)
cat /e/mostafa/Companies/Digital_Harbor/saqqar-ios-cert/saqqar-app1-1218d373239b.json | clip
```

## iOS (App Store Connect / TestFlight)

| Secret | What it is |
|---|---|
| `IOS_DIST_P12_BASE64` | Apple Distribution certificate (.p12), base64 |
| `IOS_DIST_P12_PASSWORD` | the .p12 export password |
| `ASC_KEY_ID` | App Store Connect API key id |
| `ASC_ISSUER_ID` | App Store Connect issuer id (you copy it from the website) |
| `ASC_KEY_P8` | contents of the `AuthKey_<id>.p8` file |

```bash
# IOS_DIST_P12_BASE64   (Apple Distribution: COMPANY DIGITAL HARBOR, valid until 2027-08-17)
base64 -w0 /e/mostafa/Companies/Digital_Harbor/saqqar-ios-cert/ios_dist.p12 | clip

# IOS_DIST_P12_PASSWORD
head -n1 "/e/mostafa/Companies/Digital_Harbor/saqqar-ios-cert/Enter Export Password  Mostafa.txt" | sed -E 's/^.*[:=] *//' | tr -d '\r\n' | clip

# ASC_KEY_ID  (taken from the file name AuthKey_2G7RZ7Y856.p8)
printf '2G7RZ7Y856' | clip

# ASC_KEY_P8
cat /e/mostafa/Companies/Digital_Harbor/saqqar-ios-cert/AuthKey_2G7RZ7Y856.p8 | clip

# ASC_ISSUER_ID: not stored anywhere locally.
# App Store Connect → Users and Access → Integrations → App Store Connect API → "Issuer ID" (a UUID).
```

## One-time steps that cannot be automated

1. **Google Play Console**: create the app `net.digitalharbor.sijillak`, and upload the first
   `.aab` by hand once (the API cannot create an app or its very first release). Then
   *Users and permissions → invite* the service-account e-mail (`client_email` in the JSON) and
   give it release permission on this app. Enable Play App Signing when asked.
2. **App Store Connect**: create the app record with bundle id `net.digitalharbor.sijillak`
   (the bundle id is registered automatically at the first export; the app record is not).
   The API key needs the **Admin** or **App Manager** role so Xcode may create the profile.
3. Put the real API URLs in `env/prod.json` / `env/staging.json` (the workflow warns while they
   still contain `.example`).
4. Back up `E:\mostafa\Companies\Digital_Harbor\_keystores\sijilak\` — losing the upload key means
   a key-reset request to Google.

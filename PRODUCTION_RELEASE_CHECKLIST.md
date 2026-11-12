# 🚀 Aeritx Production Release Checklist - Google Play Store

**App Version:** 1.0.0 (Build 1)  
**Package Name:** com.aeritx.app  
**Build Date:** November 14, 2025

---

## ✅ COMPLETED TASKS

### 1. ✅ Production Keystore Generated
- **Location:** `android/upload-keystore.jks`
- **Algorithm:** RSA 2048-bit
- **Validity:** 10,000 days (~27 years)
- **Credentials:** Stored in `android/key.properties` and `KEYSTORE_CREDENTIALS_SECURE.txt`
- **⚠️ CRITICAL:** Keystore backup created. **DO NOT LOSE THIS FILE!** Without it, you cannot update the app on Play Store.

### 2. ✅ Production API Endpoint Configured
- **Endpoint:** `https://aeritx.com/api`
- **Status:** Hardcoded as constant (no fallback to staging)
- **File:** `lib/_core/strings/endpoints.dart`

### 3. ✅ Version Number Reset
- **Version:** 1.0.0+1 (versionName 1.0.0, versionCode 1)
- **File:** `pubspec.yaml`
- **Reason:** New app with new package name (not an update)

### 4. ✅ Signed Release AAB Built
- **File:** `build/app/outputs/bundle/release/app-release.aab`
- **Size:** 71.6 MB (75,113,187 bytes)
- **Signed:** Yes (with production keystore)
- **Architectures:** arm64-v8a, armeabi-v7a, x86_64

### 5. ✅ Debug Logging Removed
- Production builds automatically disable console logs via `kDebugMode` flag
- Verbose debug statements removed from home page repository and models

### 6. ✅ AamarPay URLs Updated
- Callback URLs now use `https://aeritx.com/payment/*` domain
- No hardcoded references to old `cartuser.com` domain

### 7. ✅ App Branding Complete
- App name: "Aeritx" (in all manifests)
- Package: com.aeritx.app
- Description: "Aeritx - Your trusted e-commerce shopping companion"

---

## ⚠️ CRITICAL ITEMS REQUIRING YOUR INPUT

### 1. 🔴 Google Maps API Key (REQUIRED)
**Current Status:** Placeholder value "api_key"  
**File:** `android/app/src/main/AndroidManifest.xml` (line ~50)  
**Action Required:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create/select your project
3. Enable "Maps SDK for Android"
4. Create an Android API key
5. Restrict the key to your package name: `com.aeritx.app`
6. Replace `android:value="api_key"` with your actual key

**Without this:** Maps functionality will not work in the app.

---

### 2. 🔴 Security: Cleartext Traffic (PRODUCTION ISSUE)
**Current Status:** `usesCleartextTraffic="true"` in AndroidManifest.xml  
**File:** `android/app/src/main/AndroidManifest.xml`  
**Risk:** Allows unencrypted HTTP connections (security vulnerability)  
**Action Required:**
- Since your API uses HTTPS (`https://aeritx.com/api`), you should set this to `false`
- **OR** remove the attribute entirely (defaults to false on API 28+)

**Recommendation:** Change to `android:usesCleartextTraffic="false"` or remove the line.

---

### 3. 🟡 Payment Gateway Verification (IMPORTANT)
**Action Required:** Verify ALL payment gateways in your backend admin panel are in **PRODUCTION MODE**:

**Payment Gateways in App:**
- ✅ **eSewa:** Uses backend `isSandbox` flag
- ✅ **Nagad:** Uses backend sandbox flag
- ✅ **Bkash:** Uses backend sandbox flag
- ✅ **PayPal:** Uses backend sandbox flag
- ✅ **AamarPay:** Uses backend sandbox flag + production callback URLs
- ⚠️ **Razorpay:** Currently FILTERED OUT (missing package - known issue)

**Steps:**
1. Log into your backend admin panel
2. Navigate to payment gateway settings
3. Ensure ALL gateways are set to "Production" or "Live" mode (NOT sandbox/test)
4. Test each payment method with small real transactions

---

### 4. 🟡 Firebase Push Notifications (OPTIONAL)
**Current Status:** Disabled (`FireMessage.isFireActive = false`)  
**Action Required (if you want push notifications):**
1. Set `FireMessage.isFireActive = true` in code
2. Ensure `google-services.json` is configured for production Firebase project
3. Test push notifications before release

**If you don't need push notifications:** Leave as-is (disabled).

---

### 5. 🟡 ProGuard/R8 Code Shrinking (OPTIONAL)
**Current Status:** Disabled (`minifyEnabled false`, `shrinkResources false`)  
**Impact:** Larger APK size (~71.6 MB), no code obfuscation  
**Benefit if enabled:** Smaller APK, harder to reverse-engineer

**Action Required (if you want to enable):**
1. Set `minifyEnabled true` and `shrinkResources true` in `android/app/build.gradle`
2. Uncomment ProGuard rules
3. **THOROUGHLY TEST** the release build (R8 can break functionality)
4. Add `-dontwarn` rules for any warnings

**Recommendation for first release:** Keep disabled to avoid potential issues. Enable in future updates after thorough testing.

---

## 📋 RECOMMENDED TESTING STEPS

### Pre-Submission Testing
1. **Install the AAB on test device:**
   ```bash
   # Use bundletool to generate APKs from AAB
   bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=aeritx.apks --mode=universal
   bundletool install-apks --apks=aeritx.apks
   ```

2. **Test Critical User Flows:**
   - [ ] User registration and login
   - [ ] Browse products and categories
   - [ ] Search functionality
   - [ ] Add products to cart
   - [ ] Wishlist add/remove
   - [ ] Checkout process
   - [ ] Payment with EACH enabled gateway (small real transactions)
   - [ ] Order history
   - [ ] Profile management
   - [ ] Address management (test Google Maps if API key added)
   - [ ] Seller chat functionality
   - [ ] Campaign/flash sale products

3. **Test New Arrivals Section:**
   - [ ] Verify "New Arrivals" section displays products correctly
   - [ ] Confirm no parsing errors in logs

4. **Performance Testing:**
   - [ ] App startup time
   - [ ] Smooth scrolling on product lists
   - [ ] Image loading performance
   - [ ] No crashes or ANRs (Application Not Responding)

5. **Edge Cases:**
   - [ ] Poor network conditions
   - [ ] No internet connection (verify error handling)
   - [ ] Empty states (no products, empty cart, etc.)
   - [ ] Large cart (20+ items)

---

## 🏪 GOOGLE PLAY CONSOLE SETUP REQUIREMENTS

### Before Uploading AAB

1. **Create App in Play Console:**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app
   - Select "App" (not Game)
   - Choose "Free" or "Paid"

2. **App Access:**
   - Declare if app requires login
   - Provide test credentials if needed

3. **Ads Declaration:**
   - Declare if app contains ads

4. **Content Rating:**
   - Complete content rating questionnaire
   - Get IARC rating certificate

5. **Target Audience:**
   - Select target age groups
   - Declare if app is directed at children

6. **Data Safety:**
   - Declare what data is collected (user accounts, payment info, location, etc.)
   - Explain how data is used
   - Describe security practices
   - Link to privacy policy (REQUIRED)

### Store Listing Assets (REQUIRED)

1. **App Icon:**
   - 512 x 512 px
   - 32-bit PNG (with alpha)
   - Already have: `android/app/src/main/res/mipmap-*/ic_launcher.png`

2. **Feature Graphic:**
   - 1024 x 500 px
   - JPG or 24-bit PNG (no alpha)
   - **ACTION REQUIRED:** Create this graphic

3. **Screenshots (Phone - REQUIRED):**
   - Minimum 2, maximum 8
   - JPEG or 24-bit PNG (no alpha)
   - Minimum dimension: 320px
   - Maximum dimension: 3840px
   - **ACTION REQUIRED:** Capture screenshots from app

4. **Screenshots (Tablet - OPTIONAL but recommended):**
   - Same requirements as phone
   - Shows app works well on tablets

5. **App Description:**
   - **Short description:** Max 80 characters
   - **Full description:** Max 4000 characters
   - **ACTION REQUIRED:** Write compelling descriptions

6. **App Category:**
   - Select primary category (e.g., "Shopping")
   - Optional: Select secondary category

7. **Contact Details:**
   - Email address (visible to users)
   - Phone number (optional)
   - Website (optional but recommended)

8. **Privacy Policy URL (REQUIRED):**
   - Must be publicly accessible
   - Must explain data collection and usage
   - **ACTION REQUIRED:** Create and host privacy policy

---

## ⚠️ KNOWN ISSUES & WARNINGS

### 1. Razorpay Payment Gateway
- **Status:** Currently filtered out in code
- **Reason:** Missing package/dependency
- **Impact:** Users cannot pay with Razorpay
- **Recommendation:** Fix in future update or remove from backend

### 2. New Arrivals Section
- **Status:** Fix implemented but not verified on device
- **Recommendation:** Test thoroughly before release

### 3. Dependency Updates
- **Status:** 72 packages have newer versions available
- **Recommendation:** Update dependencies in future releases (not before first release)

### 4. Flutter Analyze Issues
- **Status:** 31 pre-existing analysis issues
- **Impact:** Mostly warnings, no critical errors
- **Recommendation:** Address in future updates

---

## 📝 FINAL PRE-SUBMISSION CHECKLIST

Before uploading to Play Console:

- [ ] Google Maps API key added (if using maps)
- [ ] `usesCleartextTraffic` set to `false` or removed
- [ ] All payment gateways verified in production mode
- [ ] AAB tested on real device
- [ ] All critical user flows tested
- [ ] Privacy policy created and hosted
- [ ] Store listing assets prepared (icon, feature graphic, screenshots)
- [ ] App descriptions written
- [ ] Content rating completed
- [ ] Data safety form completed
- [ ] Keystore backed up securely (CRITICAL!)

---

## 🎯 NEXT STEPS

1. **Address critical items** (Google Maps API, cleartext traffic, payment verification)
2. **Test the AAB** thoroughly on real devices
3. **Prepare store listing assets** (screenshots, feature graphic, descriptions)
4. **Create privacy policy** and host it publicly
5. **Complete Play Console setup** (content rating, data safety, etc.)
6. **Upload AAB** to Play Console (Internal Testing track first)
7. **Submit for review** once all requirements met

---

## 📞 SUPPORT

If you encounter any issues during the release process:
- Check [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- Review [Flutter deployment guide](https://docs.flutter.dev/deployment/android)
- Consult with your backend team for payment gateway configuration

---

**Good luck with your release! 🚀**


# Phase 2: Testing Instructions

**Project**: Flutter E-Commerce Application (cartuser-source-v1.9.0)
**Date**: November 7, 2025
**Device**: RMX3842 (Android 15, API 35)

---

## 📋 PRE-TESTING CHECKLIST

Before starting testing, ensure:

- [ ] Android device (RMX3842) is connected via USB debugging
- [ ] Device is recognized by `flutter devices`
- [ ] Device has sufficient storage (at least 500MB free)
- [ ] Device battery is above 50%
- [ ] Device is on stable WiFi or mobile network
- [ ] Flutter SDK is up to date: `flutter upgrade`
- [ ] Dependencies are resolved: `flutter pub get`

---

## 🚀 BUILD AND DEPLOYMENT

### Step 1: Clean Build
```bash
cd c:\Users\admin\Desktop\cartuser-source-v1.9.0
flutter clean
flutter pub get
```

### Step 2: Run on Device
```bash
flutter run -d <device-id>
```

**Expected Output**:
- Build completes successfully (no errors)
- App launches on device
- No crashes or runtime errors
- App displays with Primary Blue theme

### Step 3: Verify Build Success
- [ ] Build completes without errors
- [ ] App launches successfully
- [ ] No runtime crashes
- [ ] App is responsive

---

## 🎨 VISUAL VERIFICATION TESTS

### Test 1: Primary Blue Color Theme
**Location**: All screens
**Expected**: Primary Blue (#1976D2) visible on buttons, links, badges

**Steps**:
1. Launch app
2. Navigate to homepage
3. Verify all buttons are Primary Blue
4. Check product cards for blue discount badges
5. Verify navigation items use Primary Blue

**Pass Criteria**: ✅ All primary UI elements are Primary Blue

---

### Test 2: Discount Badges
**Location**: Product cards
**Expected**: Blue background with white text

**Steps**:
1. Go to homepage
2. Look at product cards with discounts
3. Verify badge background is Primary Blue
4. Verify text is white and readable

**Pass Criteria**: ✅ Badges display in Primary Blue with white text

---

### Test 3: Payment Success Screen
**Location**: After payment
**Expected**: Success message in Primary Blue

**Steps**:
1. Complete a payment (or use test payment)
2. Verify success screen displays
3. Check that success icon/text is Primary Blue

**Pass Criteria**: ✅ Success screen uses Primary Blue

---

### Test 4: 404 Error Page
**Location**: Invalid route
**Expected**: Error path text in Primary Blue

**Steps**:
1. Navigate to invalid URL (e.g., `/invalid-page`)
2. Verify 404 page displays
3. Check that error path text is Primary Blue

**Pass Criteria**: ✅ 404 page uses Primary Blue

---

### Test 5: Homepage Layout
**Location**: Homepage
**Expected**: Store section removed, clean layout

**Steps**:
1. Go to homepage
2. Scroll through all sections
3. Verify Store section is NOT present
4. Verify no empty gaps or broken layouts
5. Verify all other sections display correctly

**Pass Criteria**: ✅ Store section removed, layout is clean

---

### Test 6: Seller Chat Button
**Location**: Product details page
**Expected**: Button visible and uses Primary Blue

**Steps**:
1. Go to any product details page
2. Verify Seller Chat button is visible (if logged in)
3. Check button uses Primary Blue colors
4. Click button to verify it works

**Pass Criteria**: ✅ Seller Chat button visible and functional

---

## 📱 RESPONSIVE DESIGN TESTS

### Test 7: Mobile Layout (360px)
**Expected**: Proper layout on mobile width

**Steps**:
1. Rotate device to portrait
2. Verify homepage displays correctly
3. Check product grid shows 2 columns
4. Verify text doesn't overflow
5. Check buttons are touchable

**Pass Criteria**: ✅ Mobile layout works correctly

---

### Test 8: Tablet Layout (600px+)
**Expected**: Proper layout on tablet width

**Steps**:
1. Rotate device to landscape
2. Verify homepage displays correctly
3. Check product grid shows 3+ columns
4. Verify text wraps properly
5. Check buttons are properly sized

**Pass Criteria**: ✅ Tablet layout works correctly

---

## 🔄 REGRESSION TESTS

### Test 9: Critical User Flows
**Expected**: All flows work without errors

**Steps**:
1. **Login**: Test login flow
2. **Search**: Search for products
3. **Product Details**: View product details
4. **Add to Cart**: Add product to cart
5. **Checkout**: Complete checkout
6. **Payment**: Process payment
7. **Order Confirmation**: View order confirmation

**Pass Criteria**: ✅ All flows work without crashes

---

### Test 10: Navigation
**Expected**: All navigation works correctly

**Steps**:
1. Test bottom navigation tabs
2. Test drawer menu items
3. Test back button
4. Test deep links (if available)

**Pass Criteria**: ✅ All navigation works correctly

---

## 🎯 ACCESSIBILITY TESTS

### Test 11: Contrast Ratios
**Expected**: WCAG AA compliance (4.5:1 minimum)

**Steps**:
1. Use accessibility checker tool
2. Verify Primary Blue on white meets 4.5:1
3. Verify white text on Primary Blue meets 4.5:1
4. Check all text is readable

**Pass Criteria**: ✅ All contrast ratios meet WCAG AA

---

### Test 12: Dark Mode (if supported)
**Expected**: Colors adjust for dark theme

**Steps**:
1. Enable dark mode in device settings
2. Relaunch app
3. Verify colors are appropriate for dark mode
4. Check text is readable
5. Verify no color conflicts

**Pass Criteria**: ✅ Dark mode works correctly

---

## 📊 TEST SUMMARY

| Test | Status | Notes |
|------|--------|-------|
| Build Success | [ ] | |
| Primary Blue Theme | [ ] | |
| Discount Badges | [ ] | |
| Payment Success | [ ] | |
| 404 Page | [ ] | |
| Homepage Layout | [ ] | |
| Seller Chat | [ ] | |
| Mobile Layout | [ ] | |
| Tablet Layout | [ ] | |
| User Flows | [ ] | |
| Navigation | [ ] | |
| Contrast Ratios | [ ] | |
| Dark Mode | [ ] | |

---

## ✅ SIGN-OFF

**QA Tester**: ___________________
**Date**: ___________________
**Overall Status**: ☐ PASS ☐ FAIL ☐ PARTIAL

**Issues Found**:
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Notes**:
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

---

## 📞 SUPPORT

If you encounter any issues during testing:

1. Check the error message in the console
2. Review the PHASE_2_FINAL_REPORT.md for context
3. Check the PHASE_2_QA_CHECKLIST.md for detailed test cases
4. Review the PHASE_2_CHANGES_DETAILED.md for code changes

---

**Prepared by**: Augment Agent
**Date**: November 7, 2025


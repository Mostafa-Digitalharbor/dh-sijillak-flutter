# R8 / ProGuard rules for release builds.
# Flutter's Gradle plugin already adds the engine keep rules; plugins ship
# consumer rules (local_auth, flutter_secure_storage, shared_preferences, dio
# use only Dart-side HTTP). Add app-specific rules below if R8 reports issues.

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Flutter references Play Core (deferred components) optionally; not used here.
-dontwarn com.google.android.play.core.**

# Biometric (local_auth) and AndroidX security/crypto (flutter_secure_storage)
-keep class androidx.biometric.** { *; }
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# Keep line numbers for readable crash stack traces (pair with mapping.txt upload).
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

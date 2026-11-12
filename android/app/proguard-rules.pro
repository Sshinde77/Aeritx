# Starter ProGuard/R8 rules for Flutter app (Aeritx)
# Keep attributes commonly useful for stacktraces/annotations
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

# Keep Flutter embedding and plugin classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep our MainActivity (referenced from AndroidManifest)
-keep class com.aeritx.app.MainActivity { *; }

# Keep local notifications receiver referenced by name in manifest
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Optional: common SDKs referenced by name (safe to keep)
-keep class com.facebook.** { *; }

# Reduce warnings that are safe to ignore in most apps
-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**


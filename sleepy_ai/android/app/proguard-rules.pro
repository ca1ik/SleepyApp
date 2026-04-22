# Flutter Wrapper - keep generated bindings
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.**

# Google Play Billing
-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**

# Just Audio / Audio Service
-keep class com.ryanheise.** { *; }

# Hive (mirror models reflectively at runtime)
-keep class **$HiveFieldAdapter { *; }

# Suppress benign warnings from kotlinx and Java desugaring
-dontwarn kotlinx.**
-dontwarn javax.annotation.**

# shared_preferences_android 2.5 calls its Kotlin classes from Dart over JNI
# and ships no keep rules, so the release shrinker removed them and the app
# hung on the launch logo (NoSuchMethodError ... SharedPreferencesApiRegistrar).
-keep class io.flutter.plugins.sharedpreferences.** { *; }

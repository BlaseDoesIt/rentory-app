# shared_preferences_android 2.5 calls its Kotlin classes from Dart over JNI
# and ships no keep rules, so the release shrinker removed or renamed them and
# the app hung on the launch logo (NoSuchMethodError ...
# SharedPreferencesApiRegistrar.getAll). The Kotlin classes its JNI bindings
# look up by name must keep their names too.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.coroutines.** { *; }
-keep class kotlin.enums.EnumEntries { *; }
-keep class kotlin.jvm.internal.DefaultConstructorMarker { *; }

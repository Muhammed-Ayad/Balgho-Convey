# Flutter Local Notifications and Gson R8/ProGuard Rules

# 1. Preserve generic signatures, annotations, and inner classes (critical for Gson TypeToken)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# 2. Keep Flutter Local Notifications classes and models
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# 3. Keep Gson classes, TypeToken, and annotated fields
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken
-keep public class * implements com.google.gson.TypeAdapterFactory
-keep public class * implements com.google.gson.JsonSerializer
-keep public class * implements com.google.gson.JsonDeserializer

# ZEGOCLOUD chat + calls: their native SDKs are called via reflection/JNI,
# so release builds must not strip or rename them.
-keep class **.zego.** { *; }
-keep class im.zego.** { *; }
-dontwarn im.zego.**

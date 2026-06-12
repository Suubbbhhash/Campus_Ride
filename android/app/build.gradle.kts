plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.campus_ride"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // ✅ REQUIRED FOR flutter_local_notifications
    compileOptions {
        // ✅ Use Java 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // ✅ Needed for notifications plugin
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        // ✅ Kotlin also Java 11
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.campus_ride"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // ✅ REQUIRED DESUGARING LIBRARY
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.0" // only here with version
}

android {
    namespace = "com.example.machinetest"
    compileSdk = 35 // or flutter.compileSdkVersion
    defaultConfig {
        applicationId = "com.example.machinetest"
        minSdk = 23  // or flutter.minSdkVersion
        targetSdk = 34 // or flutter.targetSdkVersion
        versionCode = 1 // or flutter.versionCode
        versionName = "1.0" // or flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

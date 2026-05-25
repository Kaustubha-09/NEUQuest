plugins {
    alias(libs.plugins.android.application)
    id("com.google.gms.google-services")
}

android {
    namespace = "edu.northeastern.numad24su_group9"
    compileSdk = 34

    defaultConfig {
        applicationId = "edu.northeastern.numad24su_group9"
        minSdk = 27
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // Gemini API key is loaded from ~/.gradle/gradle.properties (not committed)
        // or the GEMINI_API_KEY environment variable. Empty fallback so the
        // build succeeds in CI without a key — GeminiClient handles the no-key case.
        val geminiApiKey = (project.findProperty("GEMINI_API_KEY") as String?)
            ?: System.getenv("GEMINI_API_KEY")
            ?: ""
        buildConfigField("String", "GEMINI_API_KEY", "\"$geminiApiKey\"")
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.coordinatorlayout)
    implementation(libs.legacy.support.v4)
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)

    implementation(libs.activity)
    implementation(libs.firebase.analytics)
    implementation(libs.constraintlayout)
    implementation(platform(libs.firebase.bom))

    implementation(libs.firebase.database)
    implementation(libs.picasso)
    implementation(libs.firebase.storage)
    implementation(libs.firebase.auth)
    implementation(libs.generativeai)
    implementation(libs.material.v130alpha02)
    implementation(libs.guava)
    implementation(libs.vipulasri.timelineview)
    implementation(libs.core.ktx.v190)
    implementation(libs.appcompat.v170alpha01)
    implementation(libs.androidx.work.runtime.ktx)
    implementation(libs.glide)

    implementation(libs.lifecycle.viewmodel)
    implementation(libs.lifecycle.livedata)
}

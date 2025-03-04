buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.10")  // Firebase services classpath
        classpath("dev.flutter:flutter-gradle-plugin:1.0.0")  // Flutter plugin classpath
    }
}

allprojects {
    repositories {
        google()  // Add Google repository for all subprojects
        mavenCentral()  // Add Maven Central repository for all subprojects
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    // Use a versão 8.11.1 para o plugin com.android.application
    id("com.android.application") version "8.11.1" apply false
    // Use a versão 4.3.10 para o plugin do Google Services
    id("com.google.gms.google-services") version "4.3.10" apply false
    // Use a versão 2.2.20 para o plugin org.jetbrains.kotlin.android
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    // Remova a declaração de versão para o plugin do Flutter Gradle
    id("dev.flutter.flutter-gradle-plugin") apply false // Removido 'version "1.0.0"'
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
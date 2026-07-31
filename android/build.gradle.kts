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

// Global JVM Toolchain: Forces Java and Kotlin across ALL modules and plugins to match JDK 17
subprojects {
    afterEvaluate {
        plugins.withId("kotlin-android") {
            configure<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension> {
                jvmToolchain(17)
            }
        }
        plugins.withId("kotlin") {
            configure<org.jetbrains.kotlin.gradle.dsl.KotlinJvmProjectExtension> {
                jvmToolchain(17)
            }
        }
    }
}

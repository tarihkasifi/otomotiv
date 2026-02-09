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

// Fix namespace for older plugins (flutter_bluetooth_serial)
subprojects {
    project.pluginManager.withPlugin("com.android.library") {
        project.extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
            if (namespace == null || namespace!!.isEmpty()) {
                namespace = project.group.toString().ifEmpty { 
                    "com.${project.name.replace("-", ".")}" 
                }
            }
        }
    }
    // Force newer AndroidX dependencies to resolve lStar attribute
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.0")
            force("androidx.core:core-ktx:1.13.0")
            force("androidx.appcompat:appcompat:1.6.1")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

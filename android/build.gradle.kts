plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
    id("com.google.firebase.appdistribution") version "5.0.0" apply false
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

subprojects {
    if (name == "isar_flutter_libs") {
        val applyNamespace = {
            try {
                val android = extensions.findByName("android")
                if (android != null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                    
                    val setCompileSdkVersion = android.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    setCompileSdkVersion.invoke(android, 36)
                    println("Injected namespace and compileSdkVersion 36 for isar_flutter_libs")
                }
            } catch (e: Exception) {
                println("Failed to inject namespace for isar_flutter_libs: ${e.message}")
            }
        }

        if (state.executed) {
            applyNamespace()
        } else {
            afterEvaluate {
                applyNamespace()
            }
        }
    }
}



tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

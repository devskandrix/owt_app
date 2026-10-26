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
// Some plugins (e.g. ZEGOCLOUD's zego_express_engine_for_uikit) still
// compile against an old Android API (31) while their dependencies need 34+.
// Raise any plugin below 34 to the app's compileSdk. Registered before
// ":app" is evaluated (next block) so the hook is in place in time.
subprojects {
    afterEvaluate {
        (extensions.findByName("android") as? com.android.build.api.dsl.LibraryExtension)
            ?.let { android ->
                if ((android.compileSdk ?: 0) < 34) android.compileSdk = 37
            }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

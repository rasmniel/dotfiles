# Launch an application over adb.
adb-launch() {
    # Set reusable app id
    test ! -z "$1" && APP_ID="$1"
    test -z "$APP_ID" && printf "No \$APP_ID argument provided\n" && return
    # Set reusable build flavor, with fallback to "Debug", i.e. installDebug
    test ! -z "$2" && BUILD_FLAVOR="$2"
    test -z "$BUILD_FLAVOR" && BUILD_FLAVOR=Debug
    ./gradlew "install$BUILD_FLAVOR" && adb -e shell monkey -p "$APP_ID" -c android.intent.category.LAUNCHER 1
}

# Launch an emulator from cold boot, no snapshop.
emulator-launch() {
    # Set reusable avd name
    test ! -z "$1" && AVD_NAME="$1"
    test -z "$AVD_NAME" && printf "No \$AVD_NAME argument provided\n" && return
    emulator -avd "$AVD_NAME" \
        -no-snapshot-load \
        -no-snapshot-save \
        -gpu swiftshader_indirect \
        -feature -Vulkan \
        -no-boot-anim \
        -verbose
}

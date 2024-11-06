# discord_timestamp
[Timestamp message](https://discord.com/developers/docs/reference#message-formatting) formatter for Discord, written with [Flutter](https://github.com/flutter).

## Features
- Format timestamp message for Discord message from picked Date/time, in precision of minutes
- Timezone offset selection
- (limited) Timestamp message preview using device localization and timezone offset

## Target Platforms
- Android
- Windows

## Getting Started
This project uses Flutter, so you will need to [have Flutter installed](https://docs.flutter.dev/get-started/install),
and all of build tools required for each target platform following Flutter's guide, i.e.:
- Windows
    - C++ build tools (from [Visual Studio installation or Build Tools for Visual Studio](https://visualstudio.microsoft.com/zh-hant/downloads/))
- Android
    - Java
    - Android SDK, including build-tools and platform-tools
      (from [Android Studio installation](https://developer.android.com/studio#android-studio)
      or [Android SDK command line tools only](https://developer.android.com/studio#command-line-tools-only))

Run `flutter build {windows | apk}`, then find the outputs under [`build/`](./build/).

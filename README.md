# daily_receipt

Print your time.
하루의 기록을 영수증으로 만들어주는 서비스

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Getting Started for Ios app with MacOs (Apple Silicon)

Clone을 받은후 해야하는 항목들이 작성되어 있습니다.

위 가이드는 Apple Silicon 기준으로 작성되었습니다.
VSCODE를 사용하고 있으며, Flutter와 Dart 확장 프로그램이 설치되어 있어야 합니다.

설치되어야 하는 항목은 아래와 같습니다.

- Visual Studio Code
  - Flutter
  - Dart
- Xcode
- cocoapods

1. Flutter SDK 설치

- [Flutter SDK 설치 가이드](https://flutter.dev/docs/get-started/install/macos)
- [Flutter SDK 다운로드](https://flutter.dev/docs/development/tools/sdk/releases?tab=macos)
  간단하게 Project를 실행을 하게 되면 VSC 오른쪽 하단에 Flutter SDK 다운로드를 요구하는 메시지가 뜨게 됩니다. 해당 메시지를 클릭하면 자동으로 Flutter SDK를 다운로드 받게 됩니다. (대부분 User 하위 폴더에 다운로드를 추천합니다.)

2. pubspec.yaml 파일 다운로드

Project에 이미 pubspec.yaml 파일이 존재하므로 해당 파일을 다운로드 받습니다.
다운로드 방법은 아래와 같습니다.

- VSCODE에서 pubspec.yaml 파일을 열어서 오른쪽 상단에 있는 'Get Packages' 버튼을 클릭합니다.
  또는 터미널에서 해당 프로젝트 폴더로 이동하여 'flutter pub get' 명령어를 입력합니다.

3. IOS Simulator 실행

- Command + Shift + P를 눌러서 'Flutter: Launch Emulator'를 입력합니다.
- IOS Simulator가 실행되면서 해당 프로젝트가 실행됩니다.

4. Debugging 실행

- Mac 화면 최상돤의 메뉴바에서 Debug 메뉴를 클릭합니다.
- Start Debugging을 클릭합니다.
- Debugging이 실행되면서 IOS Simulator가 실행되고, VSCODE의 Debugging 화면이 나타납니다.

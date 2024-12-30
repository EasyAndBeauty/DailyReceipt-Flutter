---

# **daily_receipt**  

**Print your time.**  
하루의 기록을 영수증으로 만들어주는 서비스  

**Copyright © 2024 EasyAndBeauty. All rights reserved.**  

---

## 📚 **Getting Started**

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)  
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)  

For help getting started with Flutter development, view the  
[online documentation](https://docs.flutter.dev/), which offers tutorials,  
samples, guidance on mobile development, and a full API reference.

---

## 🍏 **Getting Started for iOS app with macOS (Apple Silicon)**

Clone한 후 프로젝트를 실행하기 위해 필요한 항목들이 작성되어 있습니다.  
**Apple Silicon** 기준으로 작성되었으며, **Visual Studio Code (VSCode)**를 사용합니다.  

### ✅ **1. 필수 소프트웨어 설치**

아래 도구들이 설치되어 있어야 합니다:  

- **Visual Studio Code**  
  - Flutter Extension  
  - Dart Extension  
- **Xcode**  
- **CocoaPods**

---

### ✅ **2. Flutter SDK 설치**

Flutter SDK가 설치되어 있지 않다면 다음 가이드를 참고하세요:

- [Flutter SDK 설치 가이드](https://flutter.dev/docs/get-started/install/macos)  
- [Flutter SDK 다운로드](https://flutter.dev/docs/development/tools/sdk/releases?tab=macos)  

> **팁:** VSCode에서 프로젝트를 열면 하단에 **Flutter SDK 설치** 메시지가 나타날 수 있습니다. 메시지를 클릭하면 Flutter SDK가 자동으로 설치됩니다.  

---

### ✅ **3. 패키지 설치**

Flutter 의존성 패키지를 설치합니다.  

- VSCode에서 `pubspec.yaml` 파일을 열고 오른쪽 상단에 있는 **"Get Packages"** 버튼을 클릭합니다.  
- 터미널에서 프로젝트 폴더로 이동한 후 다음 명령어를 실행합니다:  

```bash
flutter pub get
```

---

### ✅ **4. iOS Simulator 실행**

- **Command + Shift + P**를 눌러 **"Flutter: Launch Emulator"** 를 입력합니다.  
- iOS Simulator가 실행됩니다.  

---

### ✅ **5. Debugging 실행**

- 상단 메뉴바에서 **Debug > Start Debugging**을 클릭합니다.  
- 디버깅이 실행되면서 iOS Simulator가 열리고, VSCode에서 디버깅 화면이 나타납니다.  

---

## 🚀 **6. Flavor 기반 실행 방법**

Flavor는 서로 다른 환경(개발, 스테이징, 프로덕션 등)을 구분하기 위해 사용됩니다.  
다음 명령어로 각 환경에 맞게 실행할 수 있습니다:

### 📗 **Development (dev)**  

```bash
flutter run --flavor dev -t lib/main.dart --dart-define=FLAVOR=dev
```

- **FLAVOR:** `dev`  
- **Base URL:** `http://127.0.0.1:8000`  

### 📘 **Production (prd)**  

```bash
flutter run --flavor prd -t lib/main.dart --dart-define=FLAVOR=prd
```

- **FLAVOR:** `prd`  
- **Base URL:** `https://api.example.com` // prd 업데이트시 env로 관리 변경 예정

---

## 🔄 **7. Clean Build (문제 발생 시)**

빌드 캐시가 꼬여서 문제가 발생할 경우 다음 명령어로 초기화하세요:

```bash
flutter clean
cd ios
pod install
cd ..
flutter run --flavor prd -t lib/main.dart --dart-define=FLAVOR=prd
```

---

## 💻 **8. 런처 아이콘 및 환경별 설정 (선택사항)**

환경별로 앱 아이콘 및 네이밍을 다르게 설정할 수 있습니다.  
관련 플러그인:  
- [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)  
- [`flutter_flavorizr`](https://pub.dev/packages/flutter_flavorizr)  

---

## ✅ **9. Firebase 설정**

Flavor별 Firebase 초기화를 확인하세요:  

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

---

## 📝 **10. 환경별 확인**

앱 실행 중에 현재 Flavor를 확인하려면 다음 코드를 추가하세요:

```dart
print('FLAVOR: ${const String.fromEnvironment('FLAVOR')}');
```

---

## 📄 **11. 에러 발생 시 확인 항목**

1. `FLAVOR`가 올바르게 전달되었는가?  
2. `firebase_options.dart`가 Flavor에 따라 다르게 설정되었는가?  
3. iOS Scheme 설정이 올바른가?  
4. 빌드 캐시가 초기화되었는가?  

---

## 🎯 **Reference Documentation**

- [Flutter Official Documentation](https://flutter.dev/docs)  
- [Firebase Official Documentation](https://firebase.google.com/docs)  

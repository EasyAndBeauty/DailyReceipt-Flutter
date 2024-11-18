# 🌐 ARB Excel Converter

Flutter의 ARB(Application Resource Bundle) 파일과 Excel 파일 간의 간편한 변환 도구입니다. 다국어 번역 작업을 더 효율적으로 관리할 수 있게 도와줍니다.

## ✨ 주요 기능

- 📝 여러 언어의 ARB 파일을 하나의 Excel 파일로 통합
- 📊 Excel 파일을 각 언어별 ARB 파일로 변환
- 🔍 키 자동 정렬 및 정리
- 📋 설명(description) 및 메타데이터 유지
- 🎨 보기 좋은 Excel 포맷팅

## 📋 사전 요구사항

- Dart SDK (2.12.0 이상)
- Flutter 프로젝트
- 프로젝트의 pubspec.yaml에 다음 의존성 추가:

```yaml
dev_dependencies:
  excel: ^4.0.0
  args: ^2.4.2
```

## 🚀 시작하기

1. 의존성 설치:

```bash
flutter pub get
```

2. 프로젝트에 tool 디렉토리 생성 (없는 경우):

```bash
mkdir -p tool/arb-excel-converter
```

3. 파일 구조:

```
📦tool
 ┗ 📂arb-excel-converter
   ┣ 📜README.md
   ┗ 📜index.dart
```

## 💻 사용법

### ARB -> Excel 변환

```bash
# 기본 경로 사용 (lib/l10n -> translations.xlsx)
dart run tool/arb-excel-converter/index.dart --to-excel

# 커스텀 경로 지정
dart run tool/arb-excel-converter/index.dart --to-excel -i lib/l10n -o custom.xlsx
```

### Excel -> ARB 변환

```bash
# 기본 경로 사용 (translations.xlsx -> lib/l10n)
dart run tool/arb-excel-converter/index.dart --to-arb

# 커스텀 경로 지정
dart run tool/arb-excel-converter/index.dart --to-arb -i custom.xlsx -o lib/l10n
```

### arb변환 이후에 l10n 파일 생성

```bash
flutter gen-l10n
```

### 사용 가능한 옵션

| 옵션             | 설명                    | 기본값                              |
| ---------------- | ----------------------- | ----------------------------------- |
| `--help`, `-h`   | 도움말 표시             | -                                   |
| `--to-excel`     | ARB를 Excel로 변환      | -                                   |
| `--to-arb`       | Excel을 ARB로 변환      | -                                   |
| `--input`, `-i`  | 입력 파일/디렉토리 경로 | `lib/l10n` 또는 `translations.xlsx` |
| `--output`, `-o` | 출력 파일/디렉토리 경로 | `translations.xlsx` 또는 `lib/l10n` |

## 📝 Excel 파일 형식

생성되는 Excel 파일의 구조:

| Key     | Description   | en      | ko         | ja         | ... |
| ------- | ------------- | ------- | ---------- | ---------- | --- |
| hello   | 인사말 메시지 | Hello   | 안녕하세요 | こんにちは | ... |
| welcome | 환영 메시지   | Welcome | 환영합니다 | ようこそ   | ... |

## 🔍 세부 기능

- **자동 정렬**: 키가 알파벳순으로 정렬됩니다.
- **메타데이터 보존**: ARB 파일의 설명과 플레이스홀더 정보가 유지됩니다.
- **누락 감지**: 번역이 누락된 항목을 쉽게 확인할 수 있습니다.
- **포맷 유지**: 번역 시 원본 ARB 파일의 포맷이 유지됩니다.

## ⚠️ 주의사항

- Excel 파일 편집 시 키(Key) 열은 수정하지 않는 것이 좋습니다.
- 새로운 언어 추가는 새 열을 추가하여 수행합니다.
- Description은 모든 언어에 공통으로 적용됩니다.

```

```

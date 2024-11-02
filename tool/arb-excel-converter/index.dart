// tool/arb_excel_converter.dart

import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: '도움말을 표시합니다.', negatable: false)
    ..addFlag('to-excel', help: 'ARB를 Excel로 변환합니다.', negatable: false)
    ..addFlag('to-arb', help: 'Excel을 ARB로 변환합니다.', negatable: false)
    ..addOption('input', abbr: 'i', help: '입력 파일 경로')
    ..addOption('output', abbr: 'o', help: '출력 파일 경로');

  final args = parser.parse(arguments);

  if (args['help'] || (!args['to-excel'] && !args['to-arb'])) {
    printUsage(parser);
    return;
  }

  final converter = ArbExcelConverter();

  if (args['to-excel']) {
    converter.arbToExcel(
      inputPath: args['input'] ?? 'lib/l10n',
      outputPath: args['output'] ?? 'lib/l10n/translations.xlsx',
    );
  } else if (args['to-arb']) {
    converter.excelToArb(
      inputPath: args['input'] ?? 'lib/l10n/translations.xlsx',
      outputPath: args['output'] ?? 'lib/l10n',
    );
  }
}

void printUsage(ArgParser parser) {
  print('사용법: dart run tool/arb_excel_converter.dart [options]\n');
  print('옵션:');
  print(parser.usage);
}

class ArbExcelConverter {
  void arbToExcel({required String inputPath, required String outputPath}) {
    final dir = Directory(inputPath);
    if (!dir.existsSync()) {
      print('Error: 입력 디렉토리를 찾을 수 없습니다: $inputPath');
      return;
    }

    // 데이터 수집
    final headers = ['Key', 'Description'];
    final arbFiles =
        dir.listSync().where((f) => f.path.endsWith('.arb')).toList();
    final allKeys = <String>{};
    final descriptions = <String, String>{};
    final translations = <String, Map<String, String>>{};

    // 언어 코드 수집
    for (final file in arbFiles) {
      final langCode = _extractLanguageCode(file.path);
      headers.add(langCode);
    }

    // ARB 파일들에서 데이터 수집
    for (final file in arbFiles) {
      final langCode = _extractLanguageCode(file.path);
      final content = json.decode((file as File).readAsStringSync())
          as Map<String, dynamic>;

      content.forEach((key, value) {
        if (key.startsWith('@') && !key.startsWith('@@')) {
          final actualKey = key.substring(1);
          if (content[key]['description'] != null) {
            descriptions[actualKey] = content[key]['description'];
          }
        } else if (!key.startsWith('@')) {
          allKeys.add(key);
          translations.putIfAbsent(key, () => {});
          translations[key]![langCode] = value.toString();
        }
      });
    }

    // Excel 생성
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1']; // Sheet1 사용

    // 헤더 스타일
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    // 헤더 삽입
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(
        columnIndex: i,
        rowIndex: 0,
      ));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // 데이터 행 추가
    final sortedKeys = allKeys.toList()..sort();
    for (var rowIndex = 0; rowIndex < sortedKeys.length; rowIndex++) {
      final key = sortedKeys[rowIndex];

      // 키
      sheet
          .cell(CellIndex.indexByColumnRow(
            columnIndex: 0,
            rowIndex: rowIndex + 1,
          ))
          .value = TextCellValue(key);

      // 설명
      sheet
          .cell(CellIndex.indexByColumnRow(
            columnIndex: 1,
            rowIndex: rowIndex + 1,
          ))
          .value = TextCellValue(descriptions[key] ?? '');

      // 각 언어별 번역
      var colIndex = 2;
      for (final file in arbFiles) {
        final langCode = _extractLanguageCode(file.path);
        sheet
            .cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex,
              rowIndex: rowIndex + 1,
            ))
            .value = TextCellValue(translations[key]?[langCode] ?? '');
        colIndex++;
      }
    }

    // Excel 파일 저장
    final outputFile = File(outputPath);
    outputFile.writeAsBytesSync(excel.save()!);
    print('✅ Excel 파일이 생성되었습니다: $outputPath');
  }

  void excelToArb({required String inputPath, required String outputPath}) {
    final file = File(inputPath);
    if (!file.existsSync()) {
      print('Error: Excel 파일을 찾을 수 없습니다: $inputPath');
      return;
    }

    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.sheets['Sheet1']!; // Sheet1 사용

    // 헤더 읽기
    final headers = <String>[];
    for (var cell in sheet.rows[0]) {
      if (cell?.value != null) {
        headers.add(cell!.value.toString());
      }
    }

    // 언어별 ARB 데이터 준비
    final arbData = <String, Map<String, dynamic>>{};
    for (var i = 2; i < headers.length; i++) {
      arbData[headers[i]] = {'@@locale': headers[i]};
    }

    // 데이터 행 처리
    for (var rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
      final row = sheet.row(rowIndex);
      if (row.isEmpty || row[0]?.value == null) continue;

      final key = row[0]!.value.toString();
      final description = row[1]?.value?.toString() ?? '';

      // 각 언어별 번역 처리
      for (var i = 2; i < headers.length; i++) {
        final langCode = headers[i];
        final translation = row[i]?.value?.toString() ?? '';

        if (translation.isNotEmpty) {
          arbData[langCode]![key] = translation;

          // 메타데이터 추가
          if (description.isNotEmpty) {
            arbData[langCode]!['@$key'] = {
              'description': description,
              'type': 'text',
              'placeholders': {}
            };
          }
        }
      }
    }

    // ARB 파일 생성
    final outputDir = Directory(outputPath);
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    arbData.forEach((langCode, data) {
      final arbFile = File('$outputPath/app_$langCode.arb');
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      arbFile.writeAsStringSync(jsonString);
      print('✅ ARB 파일이 생성되었습니다: ${arbFile.path}');
    });
  }

  String _extractLanguageCode(String filePath) {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final match = RegExp(r'app_(\w+)\.arb').firstMatch(fileName);
    return match?.group(1) ?? 'unknown';
  }
}

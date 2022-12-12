import 'dart:core';
import 'dart:io';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getTotalPriority1;
  base.calculateSecond = _getTotalPriority2;
  base.exampleAnswerFirst = 157;
  base.exampleAnswerSecond = 70;

  alphabeth = await File('./lib/base/alphabet').readAsLines();

  await base.calculate(3);
}

late List<String> alphabeth;

int _getTotalPriority1(List<String> dataLines) {
  int total = 0;
  for (String line in dataLines) {
    final int halfCharCount = (line.length / 2).floor();
    final List<String> firstHalf = line.substring(0, halfCharCount).split('');
    final List<String> secondHalf = line.substring(halfCharCount).split('');
    final String commonChar =
        firstHalf.firstWhere((String char) => secondHalf.contains(char));
    total += alphabeth.indexOf(commonChar) + 1;
  }
  return total;
}

int _getTotalPriority2(List<String> dataLines) {
  int total = 0;
  for (int i = 1; i <= dataLines.length; i++) {
    if (i % 3 == 0) {
      final String commonChar = dataLines[i - 1].split('').firstWhere(
          (String char) =>
              dataLines[i - 2].split('').contains(char) &&
              dataLines[i - 3].split('').contains(char));
      total += alphabeth.indexOf(commonChar) + 1;
    }
  }
  return total;
}

import 'dart:core';
import 'dart:io';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getTotalPriority1;
  base.calculateSecond = _getTotalPriority2;
  base.exampleAnswerFirst = 157;
  base.exampleAnswerSecond = 70;

  alphabeth = await File('./input/day3/alphabet').readAsLines();

  await base.calculate(3);
}

late List<String> alphabeth;

int _getTotalPriority1(List<String> dataLines) {
  int total = 0;
  for (String line in dataLines) {
    final int halfCharCount = (line.length / 2).floor();
    final List<String> firstHalf = line.substring(0, halfCharCount).split('');
    final List<String> secondHalf = line.substring(halfCharCount).split('');
    final commonChar =
        firstHalf.firstWhere((String char) => secondHalf.contains(char));
    total += alphabeth.indexOf(commonChar) + 1;
  }

  return total;
}

int _getTotalPriority2(List<String> dataLines) {
  final List<List<String>> groupsOfThree = <List<String>>[];
  for (int i = 1; i <= dataLines.length; i++) {
    if (i % 3 == 0) {
      groupsOfThree.add(dataLines.sublist(i - 3, i));
    }
  }

  int total = 0;
  for (List<String> group in groupsOfThree) {
    final commonChar = group[0].split('').firstWhere((String char) =>
        group[1].split('').contains(char) && group[2].split('').contains(char));
    total += alphabeth.indexOf(commonChar) + 1;
  }

  return total;
}

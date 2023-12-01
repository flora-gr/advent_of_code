import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 142;
  base.exampleAnswerSecond = 281;

  await base.calculate(1);
}

int _first(List<String> dataLines) {
  if (dataLines.any((String line) => line.isEmpty)) {
    final int dataSeparation =
        dataLines.indexOf(dataLines.firstWhere((String line) => line.isEmpty));
    dataLines = dataLines.sublist(0, dataSeparation);
  }

  int sum = 0;
  for (String line in dataLines) {
    final characters = line.split('');
    final first = characters.firstWhere((char) => int.tryParse(char) != null);
    final last = characters.lastWhere((char) => int.tryParse(char) != null);
    sum += int.parse(first + last);
  }
  return sum;
}

int _second(List<String> dataLines) {
  if (dataLines.any((String line) => line.isEmpty)) {
    final int dataSeparation =
        dataLines.indexOf(dataLines.firstWhere((String line) => line.isEmpty));
    dataLines = dataLines.sublist(dataSeparation + 1);
  }

  int sum = 0;
  for (String line in dataLines) {
    String? first;
    String? last;

    for (int i = 1; i <= line.length;) {
      first = numbers
          .where((entry) => line.substring(0, i).contains(entry))
          .firstOrNull;
      if (first != null) {
        if (numberMap.keys.contains(first)) {
          first = numberMap[first]!;
        }
        break;
      }
      i++;
    }

    for (int i = line.length - 1; i >= 0;) {
      last = numbers.where((entry) => line.contains(entry, i)).firstOrNull;
      if (last != null) {
        if (numberMap.keys.contains(last)) {
          last = numberMap[last]!;
        }
        break;
      }
      i--;
    }

    sum += int.parse(first! + last!);
  }
  return sum;
}

var numbers = [...numberMap.values, ...numberMap.keys];

const numberMap = {
  'one': '1',
  'two': '2',
  'three': '3',
  'four': '4',
  'five': '5',
  'six': '6',
  'seven': '7',
  'eight': '8',
  'nine': '9'
};

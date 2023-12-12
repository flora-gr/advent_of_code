import 'dart:core';
import 'package:collection/collection.dart';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 21;
  base.exampleAnswerSecond = 525152;

  await base.calculate(12);
}

int _first(List<String> dataLines) {
  var sum = 0;
  for (String line in dataLines) {
    final split = line.split(' ');
    var pattern =
        split[1].split(',').map((String num) => int.parse(num)).toList();
    var row = split[0].split('').toList();

    final replacable = <int>[];
    for (int i = 0; i < row.length; i++) {
      if (row[i] == '?') {
        replacable.add(i);
      }
    }

    final newRows = <List<String>>{List.of(row)};
    for (int index in replacable) {
      for (List<String> current in Set.of(newRows)) {
        if (current.where((String char) => char == '#').length <
            pattern.reduce((a, b) => a + b)) {
          newRows.remove(current);
          final newRow1 = List.of(current)..[index] = '#';
          if (_canMatch(newRow1, pattern)) {
            if (_matches(newRow1, pattern)) {
              sum++;
            } else {
              newRows.add(newRow1);
            }
          }
          final newRow2 = List.of(current)..[index] = '.';
          if (_canMatch(newRow2, pattern)) {
            newRows.add(newRow2);
          }
        }
      }
    }
    for (List<String> newRow in newRows) {
      if (_matches(newRow, pattern)) {
        sum++;
      }
    }
  }

  return sum;
}

int _second(List<String> dataLines) {
  return 0;
}

bool _canMatch(List<String> row, List<int> compare) {
  return row.where((String char) => char != '.').length >=
          compare.reduce((a, b) => a + b) &&
      _startMatches(row, compare);
}

bool _startMatches(List<String> row, List<int> compare) {
  final startRow = <String>[];
  for (String char in row) {
    if (char == '?') {
      break;
    }
    startRow.add(char);
  }
  final stretches = startRow
      .join()
      .split('.')
      .where(((String stretch) =>
          stretch.split('').every((String char) => char == '#')))
      .map((String stretch) => stretch.length)
      .where((int length) => length != 0)
      .toList();

  if (stretches.length > compare.length) {
    return false;
  }
  for (int i = 0; i < stretches.length - 1; i++) {
    if (stretches[i] != compare[i]) {
      return false;
    }
  }
  return true;
}

bool _matches(List<String> row, List<int> compare) {
  final pattern = <int>[];
  var inStretch = false;
  var length = 0;
  for (int i = 0; i < row.length; i++) {
    if (row[i] == '#') {
      length++;
      inStretch = true;
      if (i == row.length - 1) {
        pattern.add(length);
      }
    } else {
      if (inStretch) {
        pattern.add(length);
        if (pattern.length > compare.length ||
            pattern.last != compare[pattern.length - 1]) {
          return false;
        }
        length = 0;
        inStretch = false;
      }
    }
  }
  return pattern.equals(compare);
}

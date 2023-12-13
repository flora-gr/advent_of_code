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
  return _getOptionsSum(dataLines);
}

int _second(List<String> dataLines) {
  return _getOptionsSum(dataLines, unfold: true);
}

int _getOptionsSum(List<String> dataLines, {bool unfold = false}) {
  var sum = 0;
  for (String line in dataLines) {
    final split = line.split(' ');
    var pattern =
        split[1].split(',').map((String num) => int.parse(num)).toList();
    var row = split[0].split('').toList();

    if (unfold) {
      pattern += pattern + pattern + pattern + pattern;
      row += ['?'] + row + ['?'] + row + ['?'] + row + ['?'] + row;
    }

    sum += _getOptions(row, pattern);
  }

  return sum;
}

int _getOptions(List<String> row, List<int> pattern) {
  if (_matches(row, pattern)) {
    return 1;
  } else if (_canMatch(row, pattern) && row.contains('?')) {
    var i = row.indexOf('?');
    final newRow1 = List.of(row)..[i] = '#';
    final newRow2 = List.of(row)..[i] = '.';
    return _getOptions(newRow1, pattern) + _getOptions(newRow2, pattern);
  }

  return 0;
}

bool _canMatch(List<String> row, List<int> pattern) {
  return row.where((String char) => char != '.').length >=
          pattern.reduce((a, b) => a + b) &&
      _startMatches(row, pattern);
}

bool _startMatches(List<String> row, List<int> pattern) {
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
      .map((String stretch) => stretch.length)
      .where((int length) => length != 0)
      .toList();

  if (stretches.length > pattern.length) {
    return false;
  }
  for (int i = 0; i < stretches.length - 1; i++) {
    if (stretches[i] != pattern[i]) {
      return false;
    }
  }
  return true;
}

bool _matches(List<String> row, List<int> pattern) {
  final current = <int>[];
  var inStretch = false;
  var length = 0;
  for (int i = 0; i < row.length; i++) {
    if (row[i] == '#') {
      length++;
      inStretch = true;
      if (i == row.length - 1) {
        current.add(length);
      }
    } else {
      if (inStretch) {
        current.add(length);
        if (current.length > pattern.length ||
            current.last != pattern[current.length - 1]) {
          return false;
        }
        length = 0;
        inStretch = false;
      }
    }
  }
  return current.equals(pattern);
}

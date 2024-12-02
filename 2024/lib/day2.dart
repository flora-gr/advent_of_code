import 'dart:core';
import 'package:collection/collection.dart';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 2;
  base.exampleAnswerSecond = 4;

  await base.calculate(2);
}

int _first(List<String> dataLines) {
  return _parseDataLines(dataLines).where(_isSafe).length;
}

int _second(List<String> dataLines) {
  var safe = 0;
  for (List<int> data in _parseDataLines(dataLines)) {
    bool currentSafe = true;
    bool safeWithSkip1 = false;
    bool safeWithSkip2 = false;
    final bool increasing = data[data.length - 1] - data[0] > 0;

    for (int i = 0; i < data.length - 1; i++) {
      var diff = data[i + 1] - data[i];
      if (increasing) {
        currentSafe = diff > 0 && diff < 4;
      } else {
        currentSafe = diff < 0 && diff > -4;
      }
      if (!currentSafe) {
        var skip1 = data
            .whereNotIndexed((index, element) => index == i + 1)
            .toList(growable: false);
        safeWithSkip1 = _isSafe(skip1);
        if (!safeWithSkip1) {
          var skip2 = data
              .whereNotIndexed((index, element) => index == i)
              .toList(growable: false);
          safeWithSkip2 = _isSafe(skip2);
        }
        break;
      }
    }

    if (currentSafe || safeWithSkip1 || safeWithSkip2) {
      safe++;
    }
  }
  return safe;
}

Iterable<List<int>> _parseDataLines(List<String> dataLines) {
  if (base.dataCache == null) {
    var parsedData = <List<int>>[];
    for (String line in dataLines) {
      parsedData.add(line.split(' ').map(int.parse).toList(growable: false));
    }
    base.dataCache = parsedData;
  }
  return base.dataCache as Iterable<List<int>>;
}

bool _isSafe(List<int> data) {
  bool safe = true;
  final bool increasing = data[data.length - 1] - data[0] > 0;
  for (int i = 0; i < data.length - 1; i++) {
    var diff = data[i + 1] - data[i];
    if (increasing) {
      safe = diff > 0 && diff < 4;
    } else {
      safe = diff < 0 && diff > -4;
    }
    if (!safe) {
      break;
    }
  }
  return safe;
}

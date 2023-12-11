import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 374;
  base.exampleAnswerSecond = 8410;

  await base.calculate(11);
}

int _first(List<String> dataLines) {
  return _expandAndGetDistanceSum(dataLines.sublist(1));
}

int _second(List<String> dataLines) {
  return _expandAndGetDistanceSum(
    dataLines.sublist(1),
    expansion: int.parse(dataLines[0]),
  );
}

_expandAndGetDistanceSum(List<String> dataLines, {int expansion = 2}) {
  final map = <int, List<int>>{};
  final expandableRows = <int>[];
  final expandableColumns = List.generate(dataLines[0].length, (i) => i);

  for (int i = 0; i < dataLines.length; i++) {
    final split = dataLines[i].split('');
    for (int j = 0; j < split.length; j++) {
      if (split[j] == '#') {
        if (map[i] == null) {
          map[i] = <int>[];
        }
        map[i]!.add(j);
        expandableColumns.remove(j);
      }
    }
    if (map[i] == null) {
      expandableRows.add(i);
    }
  }

  // expand horizontally
  for (int y in map.keys) {
    final newRow = <int>[];
    for (int x in map[y]!) {
      var expand = 0;
      for (int index = expandableColumns.length - 1; index >= 0; index--) {
        if (x > expandableColumns[index]) {
          expand += (expansion - 1);
        }
      }
      newRow.add(x + expand);
    }
    map[y] = newRow;
  }

  // expand vertically
  final expandedMap = <int, List<int>>{};
  for (int y in map.keys) {
    var expand = 0;
    for (int index = expandableRows.length - 1; index >= 0; index--) {
      if (y > expandableRows[index]) {
        expand += (expansion - 1);
      }
    }
    expandedMap[y + expand] = map[y]!;
  }

  final distances = <int>[];
  for (int firstY in expandedMap.keys) {
    for (int firstX in expandedMap[firstY]!) {
      final first = (firstY, firstX);
      for (int secondY in expandedMap.keys) {
        for (int secondX in expandedMap[secondY]!) {
          final second = (secondY, secondX);
          if (first != second) {
            distances.add((secondY - firstY).abs() + (secondX - firstX).abs());
          }
        }
      }
    }
  }

  return distances.reduce((a, b) => a + b) ~/ 2;
}

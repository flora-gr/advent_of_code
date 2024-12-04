import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 18;
  base.exampleAnswerSecond = 9;

  await base.calculate(4);
}

int _first(List<String> dataLines) {
  var grid = _parseData(dataLines);
  var maxI = grid.length;
  var maxJ = grid[0]!.length;

  var total = 0;
  for (int i = 0; i < maxI; i++) {
    for (int j = 0; j < maxJ; j++) {
      if (grid[i]![j].$2 == 'X') {
        // right
        if (maxJ > j + 3 &&
            grid[i]![j + 1].$2 == 'M' &&
            grid[i]![j + 2].$2 == 'A' &&
            grid[i]![j + 3].$2 == 'S') {
          total++;
        }
        // left
        if (j > 2 &&
            grid[i]![j - 1].$2 == 'M' &&
            grid[i]![j - 2].$2 == 'A' &&
            grid[i]![j - 3].$2 == 'S') {
          total++;
        }
        // up
        if (i > 2 &&
            grid[i - 1]![j].$2 == 'M' &&
            grid[i - 2]![j].$2 == 'A' &&
            grid[i - 3]![j].$2 == 'S') {
          total++;
        }
        // down
        if (maxI > i + 3 &&
            grid[i + 1]![j].$2 == 'M' &&
            grid[i + 2]![j].$2 == 'A' &&
            grid[i + 3]![j].$2 == 'S') {
          total++;
        }
        // left up
        if (i > 2 &&
            j > 2 &&
            grid[i - 1]![j - 1].$2 == 'M' &&
            grid[i - 2]![j - 2].$2 == 'A' &&
            grid[i - 3]![j - 3].$2 == 'S') {
          total++;
        }
        // right up
        if (i > 2 &&
            maxJ > j + 3 &&
            grid[i - 1]![j + 1].$2 == 'M' &&
            grid[i - 2]![j + 2].$2 == 'A' &&
            grid[i - 3]![j + 3].$2 == 'S') {
          total++;
        }
        // left down
        if (maxI > i + 3 &&
            j > 2 &&
            grid[i + 1]![j - 1].$2 == 'M' &&
            grid[i + 2]![j - 2].$2 == 'A' &&
            grid[i + 3]![j - 3].$2 == 'S') {
          total++;
        }
        // right down
        if (maxI > i + 3 &&
            maxJ > j + 3 &&
            grid[i + 1]![j + 1].$2 == 'M' &&
            grid[i + 2]![j + 2].$2 == 'A' &&
            grid[i + 3]![j + 3].$2 == 'S') {
          total++;
        }
      }
    }
  }
  return total;
}

int _second(List<String> dataLines) {
  var grid = _parseData(dataLines);
  var maxI = grid.length;
  var maxJ = grid[0]!.length;

  var total = 0;
  for (int i = 0; i < maxI; i++) {
    for (int j = 0; j < maxJ; j++) {
      if (grid[i]![j].$2 == 'A' &&
          maxI > i + 1 &&
          i > 0 &&
          maxJ > j + 1 &&
          j > 0) {
        // down
        if (grid[i - 1]![j - 1].$2 == 'M' &&
            grid[i - 1]![j + 1].$2 == 'M' &&
            grid[i + 1]![j - 1].$2 == 'S' &&
            grid[i + 1]![j + 1].$2 == 'S') {
          total++;
        }
        // up
        if (grid[i - 1]![j - 1].$2 == 'S' &&
            grid[i - 1]![j + 1].$2 == 'S' &&
            grid[i + 1]![j - 1].$2 == 'M' &&
            grid[i + 1]![j + 1].$2 == 'M') {
          total++;
        }
        // left
        if (grid[i - 1]![j - 1].$2 == 'S' &&
            grid[i - 1]![j + 1].$2 == 'M' &&
            grid[i + 1]![j - 1].$2 == 'S' &&
            grid[i + 1]![j + 1].$2 == 'M') {
          total++;
        }
        // right
        if (grid[i - 1]![j - 1].$2 == 'M' &&
            grid[i - 1]![j + 1].$2 == 'S' &&
            grid[i + 1]![j - 1].$2 == 'M' &&
            grid[i + 1]![j + 1].$2 == 'S') {
          total++;
        }
      }
    }
  }
  return total;
}

Map<int, List<(int, String)>> _parseData(List<String> dataLines) {
  if (base.dataCache == null) {
    var maxI = dataLines.length;
    var maxJ = dataLines[0].length;

    var grid = <int, List<(int, String)>>{};
    for (int i = 0; i < maxI; i++) {
      grid[i] = <(int, String)>[];
      var split = dataLines[i].split('');
      for (int j = 0; j < maxJ; j++) {
        grid[i]!.add((j, split[j]));
      }
    }
    base.dataCache = Map<int, List<(int, String)>>.from(grid);
  }
  return base.dataCache as Map<int, List<(int, String)>>;
}

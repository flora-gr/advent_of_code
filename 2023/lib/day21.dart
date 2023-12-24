import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 16;
  base.exampleAnswerSecond = 16733044;

  await base.calculate(21);
}

int _first(List<String> dataLines) {
  final current = <(int, int)>{};
  var map = <int, Map<int, String>>{};
  for (int y = 0; y < dataLines.length; y++) {
    map[y] = {};
    final row = dataLines[y].split('');
    for (int x = 0; x < dataLines.first.length; x++) {
      map[y]![x] = row[x];
      if (row[x] == 'S') {
        current.add((y, x));
      }
    }
  }

  final steps = dataLines.length < 12 ? 6 : 64;
  for (int i = 1; i <= steps; i++) {
    for ((int, int) coord in Set.of(current)) {
      current.remove(coord);
      final adjacent = [
        (coord.$1 + 1, coord.$2),
        (coord.$1 - 1, coord.$2),
        (coord.$1, coord.$2 + 1),
        (coord.$1, coord.$2 - 1),
      ];
      for ((int, int) c in adjacent) {
        if (c.$1 < map.length &&
            c.$1 >= 0 &&
            c.$2 < map[c.$1]!.length &&
            c.$2 >= 0 &&
            map[c.$1]![c.$2] != '#') {
          current.add(c);
        }
      }
    }
  }
  return current.length;
}

int _second(List<String> dataLines) {
  return 0;
}

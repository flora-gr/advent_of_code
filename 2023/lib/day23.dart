import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 94;
  base.exampleAnswerSecond = 154;

  await base.calculate(23);
}

int _first(List<String> dataLines) {
  var start = (0, 0);
  var end = (0, 0);
  var map = <int, Map<int, String>>{};
  for (int y = 0; y < dataLines.length; y++) {
    map[y] = {};
    final row = dataLines[y].split('');
    for (int x = 0; x < dataLines.first.length; x++) {
      map[y]![x] = row[x];
      if (y == 0 && row[x] == '.') {
        start = (y, x);
      } else if (y == dataLines.length - 1 && row[x] == '.') {
        end = (y, x);
      }
    }
  }

  final paths = <List<(int, int)>>[
    [start]
  ];
  while (paths.any((List<(int, int)> path) => path.last != end)) {
    for (List<(int, int)> path in List.of(paths)) {
      if (path.last != end) {
        paths.remove(path);
        final coord = path.last;
        final adjacent = [
          (coord.$1 + 1, coord.$2),
          (coord.$1 - 1, coord.$2),
          (coord.$1, coord.$2 + 1),
          (coord.$1, coord.$2 - 1),
        ];
        for ((int, int) c in adjacent) {
          if (!path.contains(c) &&
              c.$1 < map.length &&
              c.$1 >= 0 &&
              c.$2 < map[c.$1]!.length &&
              c.$2 >= 0) {
            final tile = map[c.$1]![c.$2]!;
            if (tile == '>' && !path.contains((c.$1, c.$2 + 1))) {
              paths.add(List.of(path)..addAll([c, (c.$1, c.$2 + 1)]));
            } else if (tile == '<' && !path.contains((c.$1, c.$2 - 1))) {
              paths.add(List.of(path)..addAll([c, (c.$1, c.$2 - 1)]));
            } else if (tile == '^' && !path.contains((c.$1 - 1, c.$2))) {
              paths.add(List.of(path)..addAll([c, (c.$1 - 1, c.$2)]));
            } else if (tile == 'v' && !path.contains((c.$1 + 1, c.$2))) {
              paths.add(List.of(path)..addAll([c, (c.$1 + 1, c.$2)]));
            } else if (tile == '.') {
              paths.add(List.of(path)..add(c));
            }
          }
        }
      }
    }
  }

  return paths.map((List<(int, int)> path) => path.length).reduce(max) - 1;
}

int _second(List<String> dataLines) {
  return 0;
}

import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 62;
  base.exampleAnswerSecond = 952408144115;

  await base.calculate(18);
}

int _first(List<String> dataLines) {
  var current = (0, 0);
  final trench = [current];
  for (String line in dataLines) {
    final instr = line.split(' ');
    final number = int.parse(instr[1]);
    switch (instr.first) {
      case 'U':
        for (int i = 1; i <= number; i++) {
          trench.add((current.$1 - i, current.$2));
        }
      case 'D':
        for (int i = 1; i <= number; i++) {
          trench.add((current.$1 + i, current.$2));
        }
      case 'R':
        for (int i = 1; i <= number; i++) {
          trench.add((current.$1, current.$2 + i));
        }
      case 'L':
        for (int i = 1; i <= number; i++) {
          trench.add((current.$1, current.$2 - i));
        }
    }
    current = trench.last;
  }

  final minY = trench.map(((int, int) hole) => hole.$1).reduce(min);
  final maxY = trench.map(((int, int) hole) => hole.$1).reduce(max);
  final minX = trench.map(((int, int) hole) => hole.$2).reduce(min);
  final maxX = trench.map(((int, int) hole) => hole.$2).reduce(max);

  final flooded = <(int, int)>{};
  final front = {((maxY - minY) ~/ 2, (maxX - minX) ~/ 2)};
  while (front.isNotEmpty) {
    for ((int, int) hole in Set.of(front)) {
      flooded.add(hole);
      final adjacent = [
        (hole.$1 + 1, hole.$2),
        (hole.$1 - 1, hole.$2),
        (hole.$1, hole.$2 + 1),
        (hole.$1, hole.$2 - 1)
      ];
      for ((int, int) coord in adjacent) {
        if (!flooded.contains(coord) && !trench.contains(coord)) {
          front.add(coord);
        }
      }
      front.remove(hole);
    }
  }

  return flooded.length + trench.toSet().length;
}

int _second(List<String> dataLines) {
  return 0;
}

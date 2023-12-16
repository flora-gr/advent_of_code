import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 46;
  base.exampleAnswerSecond = 51;

  await base.calculate(16);
}

int _first(List<String> dataLines) {
  return _getExcited(dataLines, (0, -1, '>'));
}

int _second(List<String> dataLines) {
  final left =
      List.generate(dataLines.length, (int i) => (i, -1, '>'), growable: false);
  final top = List.generate(dataLines.first.length, (int i) => (-1, i, 'v'),
      growable: false);
  final right = List.generate(
      dataLines.length, (int i) => (i, dataLines.first.length, '<'),
      growable: false);
  final bottom = List.generate(
      dataLines.first.length, (int i) => (dataLines.length, i, '^'),
      growable: false);
  final all = left + top + right + bottom;

  var max = 0;
  for ((int y, int x, String dir) beam in all) {
    final excited = _getExcited(dataLines, beam);
    if (excited > max) {
      max = excited;
    }
  }
  return max;
}

int _getExcited(List<String> dataLines, (int y, int x, String dir) start) {
  final mirrors = <int, Map<int, String>>{};
  for (int y = 0; y < dataLines.length; y++) {
    mirrors[y] = <int, String>{};
    for (int x = 0; x < dataLines.first.length; x++) {
      mirrors[y]![x] = dataLines[y].split('')[x];
    }
  }

  final excited = <(int y, int x)>{};
  final alreadySeen = <(int y, int x, String dir)>{};
  final current = <(int y, int x, String dir)>{start};
  while (current.isNotEmpty) {
    for ((int y, int x, String dir) beam in Set.of(current)) {
      if (beam != start) {
        excited.add((beam.$1, beam.$2));
      }
      alreadySeen.add(beam);
      final nextDir = <String>[];
      switch (beam.$3) {
        case '>':
          final next = mirrors[beam.$1]?[beam.$2 + 1];
          if (next == '.' || next == '-') {
            nextDir.add('>');
          } else if (next == '|') {
            nextDir.addAll(['^', 'v']);
          } else if (next == '\\') {
            nextDir.add('v');
          } else if (next == '/') {
            nextDir.add('^');
          }
          for (String dir in nextDir) {
            current.add((beam.$1, beam.$2 + 1, dir));
          }
        case 'v':
          final next = mirrors[beam.$1 + 1]?[beam.$2];
          if (next == '.' || next == '|') {
            nextDir.add('v');
          } else if (next == '-') {
            nextDir.addAll(['<', '>']);
          } else if (next == '\\') {
            nextDir.add('>');
          } else if (next == '/') {
            nextDir.add('<');
          }
          for (String dir in nextDir) {
            current.add((beam.$1 + 1, beam.$2, dir));
          }
        case '<':
          final next = mirrors[beam.$1]?[beam.$2 - 1];
          if (next == '.' || next == '-') {
            nextDir.add('<');
          } else if (next == '|') {
            nextDir.addAll(['^', 'v']);
          } else if (next == '\\') {
            nextDir.add('^');
          } else if (next == '/') {
            nextDir.add('v');
          }
          for (String dir in nextDir) {
            current.add((beam.$1, beam.$2 - 1, dir));
          }
        case '^':
          final next = mirrors[beam.$1 - 1]?[beam.$2];
          if (next == '.' || next == '|') {
            nextDir.add('^');
          } else if (next == '-') {
            nextDir.addAll(['<', '>']);
          } else if (next == '\\') {
            nextDir.add('<');
          } else if (next == '/') {
            nextDir.add('>');
          }
          for (String dir in nextDir) {
            current.add((beam.$1 - 1, beam.$2, dir));
          }
      }
    }
    current.removeWhere((beam) => alreadySeen.contains(beam));
  }
  return excited.length;
}

import 'dart:core';

import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 41;
  base.exampleAnswerSecond = 6;

  await base.calculate(6);
}

int _first(List<String> dataLines) {
  var maxX = dataLines[0].length - 1;
  var maxY = dataLines.length - 1;
  var map = <int, List<int>>{};
  var pos = (0, 0);
  for (int i = 0; i < dataLines.length; i++) {
    map[i] = <int>[];
    var split = dataLines[i].split('');
    for (int j = 0; j < split.length; j++) {
      if (split[j] == '#') {
        map[i]!.add(j);
      } else if (split[j] == '^') {
        pos = (i, j);
      }
    }
  }

  var visited = <(int, int)>{pos};
  var onMap = true;
  var dir = '^';
  while (onMap) {
    if (dir == '^') {
      if (pos.$1 > 0) {
        if (map[pos.$1 - 1]!.contains(pos.$2)) {
          dir = '>';
        } else {
          pos = (pos.$1 - 1, pos.$2);
        }
      } else {
        onMap = false;
      }
    } else if (dir == '>') {
      if (pos.$2 < maxX) {
        if (map[pos.$1]!.contains(pos.$2 + 1)) {
          dir = 'v';
        } else {
          pos = (pos.$1, pos.$2 + 1);
        }
      } else {
        onMap = false;
      }
    } else if (dir == 'v') {
      if (pos.$1 < maxY) {
        if (map[pos.$1 + 1]!.contains(pos.$2)) {
          dir = '<';
        } else {
          pos = (pos.$1 + 1, pos.$2);
        }
      } else {
        onMap = false;
      }
    } else if (dir == '<') {
      if (pos.$2 > 0) {
        if (map[pos.$1]!.contains(pos.$2 - 1)) {
          dir = '^';
        } else {
          pos = (pos.$1, pos.$2 - 1);
        }
      } else {
        onMap = false;
      }
    }
    visited.add(pos);
  }
  return visited.length;
}

int _second(List<String> dataLines) {
  return 0;
}

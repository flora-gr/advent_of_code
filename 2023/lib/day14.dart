import 'dart:core';
import 'package:collection/collection.dart';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 136;
  base.exampleAnswerSecond = 64;

  await base.calculate(14);
}

int _first(List<String> dataLines) {
  final map = _getMap(dataLines);
  _tiltNorth(map);
  return _getLoad(map);
}

int _second(List<String> dataLines) {
  const max = 999999999;
  final map = _getMap(dataLines);

  List<Map<int, String>> cycleResults = [];
  var checkForAlreadyCycled = true;
  for (int i = 0; i <= max; i++) {
    _tiltNorth(map);
    _tiltWest(map);
    _tiltSouth(map);
    _tiltEast(map);

    if (checkForAlreadyCycled) {
      final stringMap = _toStringMap(map);
      final matches = cycleResults
          .where((result) => MapEquality().equals(stringMap, result));
      if (matches.length == 1) {
        final index = cycleResults.indexOf(matches.single);
        i = max - (max - i) % (i - index);
        checkForAlreadyCycled = false;
      }
      cycleResults.add(stringMap);
    }
  }

  return _getLoad(map);
}

Map<int, List<String>> _getMap(List<String> dataLines) {
  if (base.dataCache == null) {
    final map = <int, List<String>>{};
    for (int y = 0; y < dataLines.length; y++) {
      for (int x = 0; x < dataLines.first.length; x++) {
        if (map[y] == null) {
          map[y] = [];
        }
        map[y]!.add(dataLines[y][x]);
      }
    }
    base.dataCache = map;
  }
  return Map.from(base.dataCache as Map<int, List<String>>);
}

int _getLoad(Map<int, List<String>> map) {
  var sum = 0;
  for (int y = 0; y < map.length; y++) {
    sum +=
        map[y]!.where((String rock) => rock == 'O').length * (map.length - y);
  }
  return sum;
}

Map<int, String> _toStringMap(Map<int, List<String>> map) {
  var newMap = <int, String>{};
  for (int key in map.keys) {
    newMap[key] = map[key]!.join();
  }
  return newMap;
}

void _tiltNorth(Map<int, List<String>> map) {
  for (int y = 1; y < map.length; y++) {
    for (int x = 0; x < map[y]!.length; x++) {
      if (map[y]![x] == 'O') {
        var canMove = true;
        var currentY = y;
        while (canMove) {
          if (currentY > 0 && map[currentY - 1]![x] == '.') {
            currentY--;
            map[y]![x] = '.';
          } else {
            canMove = false;
          }
        }
        map[currentY]![x] = 'O';
      }
    }
  }
}

void _tiltWest(Map<int, List<String>> map) {
  for (int x = 1; x < map[0]!.length; x++) {
    for (int y = 0; y < map.length; y++) {
      if (map[y]![x] == 'O') {
        var canMove = true;
        var currentX = x;
        while (canMove) {
          if (currentX > 0 && map[y]![currentX - 1] == '.') {
            currentX--;
            map[y]![x] = '.';
          } else {
            canMove = false;
          }
        }
        map[y]![currentX] = 'O';
      }
    }
  }
}

void _tiltSouth(Map<int, List<String>> map) {
  for (int y = map.length - 2; y >= 0; y--) {
    for (int x = 0; x < map[y]!.length; x++) {
      if (map[y]![x] == 'O') {
        var canMove = true;
        var currentY = y;
        while (canMove) {
          if (currentY < map.length - 1 && map[currentY + 1]![x] == '.') {
            currentY++;
            map[y]![x] = '.';
          } else {
            canMove = false;
          }
        }
        map[currentY]![x] = 'O';
      }
    }
  }
}

void _tiltEast(Map<int, List<String>> map) {
  for (int x = map[0]!.length - 2; x >= 0; x--) {
    for (int y = 0; y < map.length; y++) {
      if (map[y]![x] == 'O') {
        var canMove = true;
        var currentX = x;
        while (canMove) {
          if (currentX < map[0]!.length - 1 && map[y]![currentX + 1] == '.') {
            currentX++;
            map[y]![x] = '.';
          } else {
            canMove = false;
          }
        }
        map[y]![currentX] = 'O';
      }
    }
  }
}

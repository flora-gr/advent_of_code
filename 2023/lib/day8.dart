import 'dart:core';
import 'base/base.dart' as base;
import 'dart:math';

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 6;
  base.exampleAnswerSecond = 6;

  await base.calculate(8);
}

int _first(List<String> dataLines) {
  if (dataLines.where((String line) => line.isEmpty).length > 1) {
    dataLines = dataLines.sublist(0, 5);
  }

  final directions = dataLines[0].split('');
  final map = _getMap(dataLines);

  return _getSteps(
    map,
    directions,
    start: 'AAA',
    endWhen: (String current) => current == 'ZZZ',
  );
}

int _second(List<String> dataLines) {
  if (dataLines.where((String line) => line.isEmpty).length > 1) {
    dataLines = dataLines.sublist(6);
  }

  final directions = dataLines[0].split('');
  final map = _getMap(dataLines);

  final allSteps = <int>[];
  final start = map.keys.where((String key) => _endsWith(key, 'A'));

  for (String key in start) {
    allSteps.add(_getSteps(
      map,
      directions,
      start: key,
      endWhen: (String current) => _endsWith(current, 'Z'),
    ));
  }

  return _leastCommonMultiple(allSteps);
}

int _leastCommonMultiple(List<int> steps) {
  final lowest = steps.reduce(min);
  for (int i = 2; i < lowest; i++) {
    if (steps.every((int step) => step % i == 0)) {
      return steps.reduce((a, b) => (a * b) ~/ i);
    }
  }
  return steps.reduce((a, b) => a * b);
}

bool _endsWith(String key, String end) {
  return key.split('').last == end;
}

int _getSteps(
  Map<String, (String, String)> map,
  List<String> directions, {
  required String start,
  required bool Function(String current) endWhen,
}) {
  var steps = 0;
  var current = start;
  for (int i = 0; !endWhen(current); i++) {
    if (i == directions.length) {
      i = 0;
    }
    if (directions[i] == 'R') {
      current = map[current]!.$2;
    } else {
      current = map[current]!.$1;
    }
    steps++;
  }
  return steps;
}

Map<String, (String, String)> _getMap(List<String> dataLines) {
  final map = <String, (String, String)>{};
  for (String line in dataLines.sublist(2)) {
    final split = line
        .replaceAll(RegExp(r'[=,\(\)]'), '')
        .split(' ')
        .where((String string) => string.isNotEmpty)
        .toList();
    map[split[0]] = (split[1], split[2]);
  }
  return map;
}

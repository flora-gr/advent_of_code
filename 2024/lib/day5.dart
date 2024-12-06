import 'dart:core';
import 'package:collection/collection.dart';

import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 143;
  base.exampleAnswerSecond = 123;

  await base.calculate(5);
}

int _first(List<String> dataLines) {
  final int separation = dataLines.indexOf('');
  var rules = _getRules(dataLines, separation);
  var updates = <List<int>>[];
  for (String line in dataLines.sublist(separation + 1)) {
    updates.add(line.split(',').map(int.parse).toList(growable: false));
  }

  var total = 0;
  for (List<int> update in updates) {
    var sorted = List<int>.from(update)..sort((a, b) => _sort(a, b, rules));
    if (ListEquality().equals(update, sorted)) {
      total += sorted[(sorted.length + 1) ~/ 2 - 1];
    }
  }
  return total;
}

int _second(List<String> dataLines) {
  final int separation = dataLines.indexOf('');
  var rules = _getRules(dataLines, separation);
  var updates = <List<int>>[];
  for (String line in dataLines.sublist(separation + 1)) {
    updates.add(line.split(',').map(int.parse).toList(growable: false));
  }

  var total = 0;
  for (List<int> update in updates) {
    var sorted = List<int>.from(update)..sort((a, b) => _sort(a, b, rules));
    if (!ListEquality().equals(update, sorted)) {
      total += sorted[(sorted.length + 1) ~/ 2 - 1];
    }
  }
  return total;
}

Iterable<(int, int)> _getRules(List<String> dataLines, int separation) {
  if (base.dataCache == null) {
    var rules = <(int, int)>[];
    for (String line in dataLines.sublist(0, separation)) {
      final split = line.split('|');
      rules.add((int.parse(split[0]), int.parse(split[1])));
    }
    base.dataCache = rules;
  }
  return base.dataCache as Iterable<(int, int)>;
}

int _sort(int a, int b, Iterable<(int, int)> rules) {
  var after = rules.where((r) => r.$1 == a).map((r) => r.$2);
  var before = rules.where((r) => r.$2 == a).map((r) => r.$1);
  if (after.contains(b)) {
    return -1;
  }
  if (before.contains(b)) {
    return 1;
  }
  return 0;
}

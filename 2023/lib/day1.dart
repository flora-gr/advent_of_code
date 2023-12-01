import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 0;
  base.exampleAnswerSecond = 0;

  await base.calculate(1);
}

int _first(List<String> dataLines) {
  return 0;
}

int _second(List<String> dataLines) {
  return 0;
}

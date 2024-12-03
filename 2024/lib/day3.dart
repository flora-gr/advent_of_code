import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 161;
  base.exampleAnswerSecond = 48;

  await base.calculate(3);
}

int _first(List<String> dataLines) {
  var regex = RegExp(r'mul\([0-9]+,[0-9]+\)');
  var total = 0;
  for (String line in dataLines) {
    var muls = regex.allMatches(line).map((match) => match[0]!);
    total += muls.map(_getProduct).reduce((a, b) => a + b);
  }
  return total;
}

int _second(List<String> dataLines) {
  var regex = RegExp(r"mul\([0-9]+,[0-9]+\)|do\(\)|don't\(\)");
  var total = 0;
  var enabled = true;
  for (String line in dataLines) {
    var matches = regex.allMatches(line).map((match) => match[0]!);
    for (String match in matches) {
      if (enabled && match.startsWith('mul')) {
        total += _getProduct(match);
      } else if (match == 'do()') {
        enabled = true;
      } else if (match == "don't()") {
        enabled = false;
      }
    }
  }
  return total;
}

int _getProduct(String mul) {
  var split = mul.split(RegExp(r'[\(,\)]'));
  return int.parse(split[1]) * int.parse(split[2]);
}

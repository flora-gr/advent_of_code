import 'dart:core';

import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = BigInt.from(3749);
  base.exampleAnswerSecond = BigInt.from(11387);

  await base.calculate(7);
}

BigInt _first(List<String> dataLines) {
  var total = BigInt.zero;
  for (String line in dataLines) {
    var split = line.split(': ');
    var numbers = split[1].split(' ').map(BigInt.parse).toList();
    var answer = BigInt.parse(split[0]);
    var current = <BigInt>{numbers.first};
    for (BigInt number in numbers.sublist(1)) {
      var newCurrent = <BigInt>{};
      for (BigInt cur in current) {
        if (cur + number <= answer) {
          newCurrent.add(cur + number);
        }
        if (cur * number <= answer) {
          newCurrent.add(cur * number);
        }
      }
      current = newCurrent;
    }
    if (current.contains(answer)) {
      total += answer;
    }
  }
  return total;
}

BigInt _second(List<String> dataLines) {
  var total = BigInt.zero;
  for (String line in dataLines) {
    var split = line.split(': ');
    var numbers = split[1].split(' ').map(BigInt.parse).toList();
    var answer = BigInt.parse(split[0]);
    var current = <BigInt>{numbers.first};
    for (BigInt number in numbers.sublist(1)) {
      var newCurrent = <BigInt>{};
      for (BigInt cur in current) {
        if (cur + number <= answer) {
          newCurrent.add(cur + number);
        }
        if (cur * number <= answer) {
          newCurrent.add(cur * number);
        }
        var concat = BigInt.parse(cur.toString() + number.toString());
        if (concat <= answer) {
          newCurrent.add(concat);
        }
      }
      current = newCurrent;
    }
    if (current.contains(answer)) {
      total += answer;
    }
  }
  return total;
}

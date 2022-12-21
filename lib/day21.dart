import 'dart:core';
import 'package:rational/rational.dart';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getRootMonkeyNumber;
  base.calculateSecond = _getMyNumber;
  base.exampleAnswerFirst = 152;
  base.exampleAnswerSecond = 301;

  await base.calculate(21);
}

const String root = 'root';

int _getRootMonkeyNumber(List<String> dataLines) {
  final List<Monkey> monkeys = _getMonkeys(dataLines);

  while (_getMonkeyNumber(monkeys, root) == null) {
    _doMonkeyGame(monkeys);
  }

  return _getMonkeyNumber(monkeys, root)!.toBigInt().toInt();
}

int _getMyNumber(List<String> dataLines) {
  const String me = 'humn';

  // Try shouting zero to get addition part
  List<Monkey> monkeys = _getMonkeys(dataLines);
  List<String> rootOperation =
      monkeys.singleWhere((Monkey monkey) => monkey.name == root).operation!;
  monkeys.singleWhere((Monkey monkey) => monkey.name == me).number =
      0.toRational();
  while (_getMonkeyNumber(monkeys, rootOperation.first) == null ||
      _getMonkeyNumber(monkeys, rootOperation.last) == null) {
    _doMonkeyGame(monkeys);
  }
  final Rational leftAddition = _getMonkeyNumber(monkeys, rootOperation.first)!;
  final Rational target = _getMonkeyNumber(monkeys, rootOperation.last)!;

  // Try shouting one to get multiplication part
  monkeys = _getMonkeys(dataLines);
  monkeys.singleWhere((Monkey monkey) => monkey.name == me).number =
      1.toRational();
  while (_getMonkeyNumber(monkeys, rootOperation.first) == null ||
      _getMonkeyNumber(monkeys, rootOperation.last) == null) {
    _doMonkeyGame(monkeys);
  }
  final Rational leftIfMyNumberIsOne =
      _getMonkeyNumber(monkeys, rootOperation.first)!;
  final Rational leftMultiplication = leftIfMyNumberIsOne - leftAddition;

  final Rational answer = (target - leftAddition) / (leftMultiplication);
  return answer.toBigInt().toInt();
}

List<Monkey> _getMonkeys(List<String> dataLines) {
  final List<Monkey> monkeys = <Monkey>[];
  for (String line in dataLines) {
    final List<String> split = line.split(':');
    final List<String> numberOrOperation = split.last.split(' ');
    monkeys.add(Monkey(
      name: split.first,
      number: numberOrOperation.length == 2
          ? Rational.parse(numberOrOperation.last)
          : null,
      operation:
          numberOrOperation.length == 4 ? numberOrOperation.sublist(1) : null,
    ));
  }
  return monkeys;
}

Rational? _getMonkeyNumber(List<Monkey> monkeys, String name) {
  return monkeys.singleWhere((Monkey monkey) => monkey.name == name).number;
}

void _doMonkeyGame(List<Monkey> monkeys) {
  for (Monkey monkey
      in monkeys.where((Monkey monkey) => monkey.number == null)) {
    final Rational? first = _getMonkeyNumber(monkeys, monkey.operation!.first);
    final Rational? second = _getMonkeyNumber(monkeys, monkey.operation!.last);
    if (first != null && second != null) {
      monkey.number = _performOperation(monkey.operation![1], first, second);
    }
  }
}

Rational _performOperation(String operation, Rational first, Rational second) {
  switch (operation) {
    case '+':
      return first + second;
    case '-':
      return first - second;
    case '*':
      return first * second;
    default:
      return first / second;
  }
}

class Monkey {
  Monkey({
    required this.name,
    this.number,
    this.operation,
  });

  final String name;
  Rational? number;
  List<String>? operation;
}

import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getMonkeyBusiness1;
  base.calculateSecond = _getMonkeyBusiness2;
  base.exampleAnswerFirst = 10605;
  base.exampleAnswerSecond = 2713310158;

  await base.calculate(11);
}

int _getMonkeyBusiness1(List<String> dataLines) {
  final List<Monkey> monkeyData = _getMonkeyData(dataLines);

  for (int i = 1; i <= 20; i++) {
    for (Monkey monkey in monkeyData) {
      for (int item in monkey.items) {
        item = (monkey.operation(item) / 3).floor();
        monkeyData[monkey.nextMonkey(item)].items.add(item);
        monkey.inspectedItems++;
      }
      monkey.items.clear();
    }
  }

  return _getMonkeyBusiness(monkeyData);
}

int _getMonkeyBusiness2(List<String> dataLines) {
  final List<Monkey> monkeyData = _getMonkeyData(dataLines);

  final int commonModulusCheck = dataLines
      .where((String line) => line.contains('Test:'))
      .map(_getLastInt)
      .reduce((a, b) => a * b);

  for (int i = 1; i <= 10000; i++) {
    for (Monkey monkey in monkeyData) {
      for (int item in monkey.items) {
        item = monkey.operation(item);
        monkeyData[monkey.nextMonkey(item)]
            .items
            .add(item % commonModulusCheck);
        monkey.inspectedItems++;
      }
      monkey.items.clear();
    }
  }

  return _getMonkeyBusiness(monkeyData);
}

List<Monkey> _getMonkeyData(List<String> dataLines) {
  final List<Monkey> monkeyData = <Monkey>[];
  for (int i = 0; i < dataLines.length; i++) {
    if (dataLines[i].startsWith('Monkey')) {
      monkeyData.add(
        Monkey(
          items: dataLines[i + 1]
              .split(':')
              .last
              .split(',')
              .map((String item) => int.parse(item.trim()))
              .toList(),
          operation: _getOperation(dataLines[i + 2]),
          nextMonkey: (int item) => item % _getLastInt(dataLines[i + 3]) == 0
              ? _getLastInt(dataLines[i + 4])
              : _getLastInt(dataLines[i + 5]),
        ),
      );
    }
  }
  return monkeyData;
}

int Function(int item) _getOperation(String line) {
  List<String> split = line.split(' ');
  final bool lastIsItem = split.last == 'old';
  if (split[split.length - 2] == '+') {
    return (int item) => item + (lastIsItem ? item : int.parse(split.last));
  } else {
    return (int item) => item * (lastIsItem ? item : int.parse(split.last));
  }
}

int _getLastInt(String line) => int.parse(line.split(' ').last);

int _getMonkeyBusiness(List<Monkey> monkeyData) {
  final List<int> inspected =
      monkeyData.map((Monkey monkey) => monkey.inspectedItems).toList()..sort();
  return inspected.last * inspected[inspected.length - 2];
}

class Monkey {
  Monkey({
    required this.items,
    required this.operation,
    required this.nextMonkey,
  });

  final List<int> items;
  int inspectedItems = 0;
  final int Function(int item) operation;
  final int Function(int item) nextMonkey;
}

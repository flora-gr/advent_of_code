import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 1320;
  base.exampleAnswerSecond = 145;

  await base.calculate(15);
}

int _first(List<String> dataLines) {
  var sum = 0;
  for (String element in dataLines.first.split(',')) {
    sum += _getValue(element);
  }
  return sum;
}

int _second(List<String> dataLines) {
  final boxes = <int, List<String>>{};
  for (int i = 0; i < 256; i++) {
    boxes[i] = [];
  }

  for (String element in dataLines.first.split(',')) {
    final label = element.split('-').first.split('=').first;
    final value = _getValue(label);
    final present =
        boxes[value]!.where((String lens) => lens.split('=').first == label);

    var index = 0;
    if (present.isNotEmpty) {
      index = boxes[value]!.indexOf(present.first);
    }

    if (element.contains('=')) {
      if (present.isNotEmpty) {
        boxes[value]!.removeAt(index);
        boxes[value]!.insert(index, element);
      } else {
        boxes[value]!.add(element);
      }
    } else if (present.isNotEmpty) {
      boxes[value]!.removeAt(index);
    }
  }

  var sum = 0;
  for (int i = 0; i < 256; i++) {
    if (boxes[i]!.isNotEmpty) {
      for (int j = 0; j < boxes[i]!.length; j++) {
        sum += ((i + 1) * (j + 1) * int.parse(boxes[i]![j].split('=').last));
      }
    }
  }
  return sum;
}

int _getValue(String element) {
  var currentValue = 0;
  for (int char in element.codeUnits) {
    currentValue = (17 * (currentValue + char)) % 256;
  }
  return currentValue;
}

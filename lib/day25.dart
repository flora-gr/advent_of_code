import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getSnafu1;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = '2=-1=0';
  base.exampleAnswerSecond = '';

  await base.calculate(25);
}

String _getSnafu1(List<String> dataLines) {
  num number = 0;
  for (String line in dataLines) {
    final List<String> signs = line.split('');
    for (int i = 0; i < signs.length; i++) {
      num add = _getNumberToAdd(signs[signs.length - 1 - i], i);
      number += add;
    }
  }
  return _getSnafu(number);
}

String _second(List<String> dataLines) {
  return '-';
}

num _getNumberToAdd(String sign, int indexFromEnd) {
  switch (sign) {
    case '2':
      return pow(5, indexFromEnd) * 2;
    case '1':
      return pow(5, indexFromEnd);
    case '-':
      return -pow(5, indexFromEnd);
    case '=':
      return pow(5, indexFromEnd) * -2;
    case '0':
    default:
      return 0;
  }
}

String _getSnafu(num number) {
  int firstExp = 0;
  num firstPow = 1;
  while (number - (2 * firstPow) > 0) {
    firstExp++;
    firstPow = pow(5, firstExp);
  }

  String snafu = '';
  num currentNum = number;
  for (int i = firstExp; i >= 0; i--) {
    num currentPow = pow(5, i);
    String currentSign = '2';
    num lowestDiff = (currentNum - (2 * currentPow)).abs();
    num currentOperation = 2 * currentPow;
    if ((currentNum - currentPow).abs() < lowestDiff) {
      currentSign = '1';
      lowestDiff = (currentNum - currentPow).abs();
      currentOperation = currentPow;
    }
    if (currentNum.abs() < lowestDiff) {
      currentSign = '0';
      lowestDiff = currentNum.abs();
      currentOperation = 0;
    }
    if ((currentNum + currentPow).abs() < lowestDiff) {
      currentSign = '-';
      lowestDiff = (currentNum + currentPow).abs();
      currentOperation = -currentPow;
    }
    if ((currentNum + (2 * currentPow)).abs() < lowestDiff) {
      currentSign = '=';
      currentOperation = -2 * currentPow;
    }
    snafu += currentSign;
    currentNum -= currentOperation;
  }

  return snafu;
}

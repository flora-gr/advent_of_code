import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getSignalsAtIndices;
  base.calculateSecond = _visualizeCRT;
  base.exampleAnswerFirst = 13140;
  base.exampleAnswerSecond = '##..##..##..##..##..##..##..##..##..##..'
      '###...###...###...###...###...###...###.'
      '####....####....####....####....####....'
      '#####.....#####.....#####.....#####.....'
      '######......######......######......####'
      '#######.......#######.......#######.....';

  await base.calculate(10);
}

int _getSignalsAtIndices(List<String> dataLines) {
  final List<int> registerValues = _getRegisterValues(dataLines);
  int signal = 0;
  for (int cycle in <int>[20, 60, 100, 140, 180, 220]) {
    signal += cycle * registerValues[cycle - 1];
  }
  return signal;
}

String _visualizeCRT(List<String> dataLines) {
  final List<int> registerValues = _getRegisterValues(dataLines);
  String crtLine = '';
  for (int pixel = 0; pixel < registerValues.length; pixel++) {
    final int middle = registerValues[pixel];
    final List<int> crtRange = <int>[middle - 1, middle, middle + 1];
    if (crtRange.contains(pixel % 40)) {
      crtLine += '#';
    } else {
      crtLine += '.';
    }
    if (pixel > 0 && pixel % 40 == 0) {
      print(crtLine.substring(pixel - 40, pixel));
    }
  }
  print('\n');

  return crtLine.substring(0, 240);
}

List<int> _getRegisterValues(List<String> dataLines) {
  if (base.dataCache == null) {
    final List<int> cycles = <int>[1];
    for (String line in dataLines) {
      List<String> split = line.split(' ');
      final int previous = cycles[cycles.length - 1];
      cycles.add(previous);
      if (split.length == 2) {
        cycles.add(previous + int.parse(split.last));
      }
    }
    base.dataCache = cycles;
  }
  return base.dataCache as List<int>;
}

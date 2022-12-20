import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getExternalSurfaces;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 64;
  base.exampleAnswerSecond = 58;

  await base.calculate(18);
}

int _getExternalSurfaces(List<String> dataLines) {
  final int totalSurfaces = dataLines.length * 6;
  final Set<String> uniqueSurfaces = <String>{};
  for (String line in dataLines) {
    final List<int> cube =
        line.split(',').map((String coord) => int.parse(coord)).toList();
    uniqueSurfaces.add('(X${cube[0]},Y${cube[1]}) at Z${cube[2]}');
    uniqueSurfaces.add('(X${cube[0]},Y${cube[1]}) at Z${cube[2] + 1}');
    uniqueSurfaces.add('(Y${cube[1]},Z${cube[2]}) at X${cube[0]}');
    uniqueSurfaces.add('(Y${cube[1]},Z${cube[2]}) at X${cube[0] + 1}');
    uniqueSurfaces.add('(Z${cube[2]},X${cube[0]}) at Y${cube[1]}');
    uniqueSurfaces.add('(Z${cube[2]},X${cube[0]}) at Y${cube[1] + 1}');
  }
  final int overLappingSurfaces = totalSurfaces - uniqueSurfaces.length;
  return totalSurfaces - (overLappingSurfaces * 2);
}

int _second(List<String> dataLines) {
  return 0;
}

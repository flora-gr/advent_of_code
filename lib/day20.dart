import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getSumOfDecryptedCoords1;
  base.calculateSecond = _getSumOfDecryptedCoords2;
  base.exampleAnswerFirst = 3;
  base.exampleAnswerSecond = 1623178306;

  await base.calculate(20);
}

int _getSumOfDecryptedCoords1(List<String> dataLines) {
  return _getSumOfDecryptedCoords(dataLines);
}

int _getSumOfDecryptedCoords2(List<String> dataLines) {
  return _getSumOfDecryptedCoords(
    dataLines,
    decryptionKey: 811589153,
    cycles: 10,
  );
}

int _getSumOfDecryptedCoords(
  List<String> dataLines, {
  int decryptionKey = 1,
  int cycles = 1,
}) {
  List<Coordinate> coords = <Coordinate>[];
  for (int i = 0; i < dataLines.length; i++) {
    coords.add(Coordinate(
      originalPos: i,
      value: int.parse(dataLines[i]) * decryptionKey,
    ));
  }

  for (int i = 0; i < coords.length * cycles; i++) {
    Coordinate coord = coords.singleWhere(
        (Coordinate coord) => coord.originalPos == i % coords.length);
    final int index = coords.indexOf(coord);
    coords.remove(coord);
    final int newIndex = (index + coord.value) % coords.length;
    if (newIndex == 0) {
      coords.add(coord);
    } else {
      coords.insert(newIndex, coord);
    }
  }

  final int indexOfZero = coords
      .indexOf(coords.singleWhere((Coordinate coord) => coord.value == 0));
  return coords[(indexOfZero + 1000) % coords.length].value +
      coords[(indexOfZero + 2000) % coords.length].value +
      coords[(indexOfZero + 3000) % coords.length].value;
}

class Coordinate {
  const Coordinate({
    required this.originalPos,
    required this.value,
  });

  final int originalPos;
  final int value;
}

import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _findFirstMarker1;
  base.calculateSecond = _findFirstMarker2;
  base.exampleAnswerFirst = <int>[7, 5, 6, 10, 11];
  base.exampleAnswerSecond = <int>[19, 23, 23, 29, 26];

  await base.calculate(6);
}

Iterable<int> _findFirstMarker1(List<String> dataLines) {
  return _findFirstMarker(dataLines, 4);
}

Iterable<int> _findFirstMarker2(List<String> dataLines) {
  return _findFirstMarker(dataLines, 14);
}

List<int> _findFirstMarker(List<String> dataLines, int markerSize) {
  final List<int> markers = <int>[];
  for (String line in dataLines) {
    int firstMarker = 0;
    for (int i = markerSize; firstMarker == 0; i++) {
      final String potentialMarker = line.substring(i - markerSize, i);
      if (potentialMarker.split('').toSet().length == markerSize) {
        firstMarker = i;
        markers.add(firstMarker);
      }
    }
  }
  return markers;
}

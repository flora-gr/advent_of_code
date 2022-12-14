import 'dart:core';

import 'dart:convert';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _checkPairs;
  base.calculateSecond = _sortAndGetIndices;
  base.exampleAnswerFirst = 13;
  base.exampleAnswerSecond = 140;

  await base.calculate(13);
}

int _checkPairs(List<String> dataLines) {
  final List<Pair> pairs = <Pair>[];
  for (int i = 0; i < dataLines.length; i++) {
    if (i == 0 || dataLines[i - 1].isEmpty) {
      pairs.add(Pair(
        jsonDecode(dataLines[i]),
        jsonDecode(dataLines[i + 1]),
      ));
    }
  }

  int sum = 0;
  for (int i = 0; i < pairs.length; i++) {
    final bool? isOrdered = _isOrdered(pairs[i].left, pairs[i].right);
    if (isOrdered!) {
      sum += i + 1;
    }
  }
  return sum;
}

int _sortAndGetIndices(List<String> dataLines) {
  const String divider1 = '[[2]]';
  const String divider2 = '[[6]]';

  final List<List> packets = <List>[];
  for (String line in dataLines) {
    if (line.isNotEmpty) {
      packets.add(jsonDecode(line));
    }
  }
  packets
    ..add(jsonDecode(divider1))
    ..add(jsonDecode(divider2))
    ..sort((a, b) => _isOrdered(a, b)! ? -1 : 1);

  final List<String> packetStrings =
      packets.map((List line) => jsonEncode(line)).toList();
  return (packetStrings.indexOf(divider1) + 1) *
      (packetStrings.indexOf(divider2) + 1);
}

bool? _isOrdered(
  List left,
  List right,
) {
  bool? isOrdered;
  for (int i = 0; i < left.length; i++) {
    if (i == right.length) {
      isOrdered = false;
    } else {
      var l = left[i];
      var r = right[i];
      if (l != r) {
        if (l is int && r is int) {
          isOrdered = l < r;
        } else if (l is List && r is List) {
          isOrdered = _isOrdered(l, r);
        } else if (l is int && r is List) {
          isOrdered = _isOrdered([l], r);
        } else if (l is List && r is int) {
          isOrdered = _isOrdered(l, [r]);
        }
      }
    }
    if (isOrdered != null) {
      break;
    }
  }
  if (isOrdered == null && left.length < right.length) {
    isOrdered = true;
  }

  return isOrdered;
}

class Pair {
  const Pair(this.left, this.right);

  final List left;
  final List right;
}

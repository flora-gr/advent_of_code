import 'dart:core';
import 'package:collection/collection.dart';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 6440;
  base.exampleAnswerSecond = 5905;

  await base.calculate(7);
}

int _first(List<String> dataLines) {
  return _getSum(dataLines);
}

int _second(List<String> dataLines) {
  return _getSum(dataLines, withJokers: true);
}

int _getSum(List<String> dataLines, {bool withJokers = false}) {
  final hands = _getHands(dataLines);
  hands.sort((Hand a, Hand b) => _compare(a, b, withJokers: withJokers));
  var sum = 0;
  for (int i = hands.length - 1; i >= 0; i--) {
    sum += hands[i].bid * (i + 1);
  }
  return sum;
}

int _compare(Hand a, Hand b, {bool withJokers = false}) {
  final typeA = a.getTypeValue(withJokers: withJokers);
  final typeB = b.getTypeValue(withJokers: withJokers);
  if (typeA > typeB) {
    return 1;
  } else if (typeA < typeB) {
    return -1;
  } else {
    for (int i = 0; i < 5; i++) {
      if (a.cards[i] != b.cards[i]) {
        return _getCardValue(a.cards[i], withJokers: withJokers)
            .compareTo(_getCardValue(b.cards[i], withJokers: withJokers));
      }
    }
    return 0;
  }
}

List<Hand> _getHands(List<String> dataLines) {
  if (base.dataCache == null) {
    final hands = <Hand>[];
    for (String line in dataLines) {
      final parts = line.split(' ');
      hands.add(Hand(parts[0].split(''), int.parse(parts[1])));
    }
    base.dataCache = hands;
  }
  return base.dataCache as List<Hand>;
}

class Hand {
  const Hand(this.cards, this.bid);

  final List<String> cards;
  final int bid;
}

extension HandExtension on Hand {
  // Assertions are based on previous assertion returning as false

  bool fiveOfAKind({required bool withJokers}) {
    return cards.any((String match) => cards
        .every((String card) => card == match || withJokers && card == joker));
  }

  bool fourOfAKind({required bool withJokers}) {
    return cards.any((String match) =>
        cards
            .where(
                (String card) => card == match || withJokers && card == joker)
            .length ==
        4);
  }

  bool fullHouse({required bool withJokers}) {
    final grouped = groupBy(cards, (String card) => card);
    return grouped.values.any((List<String> v) => v.length == 3) &&
            grouped.values.any((List<String> v) => v.length == 2) ||
        withJokers &&
            grouped.values
                .any((List<String> v) => v.length == 1 && v[0] == joker) &&
            grouped.values.where((List<String> v) => v.length == 2).length == 2;
  }

  bool threeOfAKind({required bool withJokers}) {
    return cards.any((String match) =>
        cards
            .where(
                (String card) => card == match || withJokers && card == joker)
            .length ==
        3);
  }

  bool twoPair() {
    final grouped = groupBy(cards, (String card) => card);
    return grouped.values.where((List<String> v) => v.length == 2).length == 2;
  }

  bool onePair({required bool withJokers}) {
    final grouped = groupBy(cards, (String card) => card);
    return grouped.values.any((List<String> v) => v.length == 2) ||
        withJokers && cards.any((String card) => card == joker);
  }

  int getTypeValue({required bool withJokers}) {
    if (fiveOfAKind(withJokers: withJokers)) {
      return 6;
    } else if (fourOfAKind(withJokers: withJokers)) {
      return 5;
    } else if (fullHouse(withJokers: withJokers)) {
      return 4;
    } else if (threeOfAKind(withJokers: withJokers)) {
      return 3;
    } else if (twoPair()) {
      return 2;
    } else if (onePair(withJokers: withJokers)) {
      return 1;
    } else {
      return 0;
    }
  }
}

int _getCardValue(String card, {required bool withJokers}) =>
    13 - _cardSet(withJokers: withJokers).indexOf(card);

List<String> _cardSet({bool withJokers = false}) => [
      'A',
      'K',
      'Q',
      if (!withJokers) joker,
      'T',
      '9',
      '8',
      '7',
      '6',
      '5',
      '4',
      '3',
      '2',
      if (withJokers) joker,
    ];

const String joker = 'J';

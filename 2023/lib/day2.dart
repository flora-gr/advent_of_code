import 'dart:core';
import 'base/base.dart' as base;
import 'dart:math';

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 8;
  base.exampleAnswerSecond = 2286;

  await base.calculate(2);
}

int _first(List<String> dataLines) {
  final redCubes = 12;
  final greenCubes = 13;
  final blueCubes = 14;

  final games = _parseGames(dataLines);

  for (Game game in List.from(games)) {
    if (game.draws.any((({int r, int g, int b}) draw) =>
        draw.r > redCubes || draw.g > greenCubes || draw.b > blueCubes)) {
      games.remove(game);
    }
  }

  return games.map((Game game) => game.id).reduce((a, b) => a + b);
}

int _second(List<String> dataLines) {
  final games = _parseGames(dataLines);

  num sum = 0;
  for (Game game in games) {
    final maxRed =
        (game.draws.map((({int r, int g, int b}) draw) => draw.r)).reduce(max);
    final maxGreen =
        (game.draws.map((({int r, int g, int b}) draw) => draw.g)).reduce(max);
    final maxBlue =
        (game.draws.map((({int r, int g, int b}) draw) => draw.b)).reduce(max);
    sum += maxRed * maxGreen * maxBlue;
  }

  return sum as int;
}

List<Game> _parseGames(List<String> dataLines) {
  final games = <Game>[];
  for (String line in dataLines) {
    final gameParts = line.split(':');
    final game = Game(int.parse(gameParts[0].split(' ').last), []);
    final draws = gameParts[1].split(';');
    for (String draw in draws) {
      var r = 0;
      var g = 0;
      var b = 0;
      final colors = draw.split(',');
      for (String color in colors) {
        final colorData = color.trim().split(' ');
        switch (colorData) {
          case [var i, 'red']:
            r = int.parse(i);
          case [var i, 'green']:
            g = int.parse(i);
          case [var i, 'blue']:
            b = int.parse(i);
        }
      }
      game.draws.add((r: r, g: g, b: b));
    }
    games.add(game);
  }
  return games;
}

class Game {
  const Game(
    this.id,
    this.draws,
  );

  final int id;
  final List<({int r, int g, int b})> draws;
}

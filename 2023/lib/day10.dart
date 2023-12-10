import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 8;
  base.exampleAnswerSecond = 10;

  await base.calculate(10);
}

int _first(List<String> dataLines) {
  if (dataLines.any((String line) => line.isEmpty)) {
    dataLines = dataLines.sublist(0, 5);
  }

  final pipeLoop = _getPipeLoop(dataLines);
  return pipeLoop.length ~/ 2;
}

int _second(List<String> dataLines) {
  if (dataLines.any((String line) => line.isEmpty)) {
    dataLines = dataLines.sublist(6);
  }

  final map = <List<String>>[];
  for (String line in dataLines) {
    map.add(line.split(''));
  }

  final pipeLoop = _getPipeLoop(dataLines);

  var inside = 0;
  for (int y = 0; y < dataLines.length; y++) {
    final row = pipeLoop.where((Pipe pipe) => pipe.coord.$1 == y);
    for (int x = 0; x < dataLines[0].length; x++) {
      if (!row.any((Pipe pipe) => pipe.coord == (y, x))) {
        var previousCurve = '';
        var numerOfWallsCrossed = 0;
        for (int i = 0; i < x; i++) {
          if (row.any((Pipe pipe) => pipe.coord == (y, i))) {
            switch (map[y][i]) {
              case '|':
                numerOfWallsCrossed++;
              case 'F':
                previousCurve = 'F';
              case 'J':
                if (previousCurve == 'F') {
                  numerOfWallsCrossed++;
                }
                previousCurve = 'J';
              case 'L':
                previousCurve = 'L';
              case '7':
                if (previousCurve == 'L') {
                  numerOfWallsCrossed++;
                }
                previousCurve = '7';
            }
          }
        }

        if (numerOfWallsCrossed % 2 != 0) {
          inside++;
        }
      }
    }
  }

  return inside;
}

Set<Pipe> _getPipeLoop(List<String> dataLines) {
  final map = <List<String>>[];
  for (String line in dataLines) {
    map.add(line.split(''));
  }

  (int y, int x)? start;
  for (int y = 0; start == null; y++) {
    for (int x = 0; x < map[y].length; x++) {
      if (map[y][x] == 'S') {
        start = (y, x);
        break;
      }
    }
  }

  var pipes = <Pipe>[];
  if (start.$1 > 1 && ['|', 'F', '7'].contains(map[start.$1 - 1][start.$2])) {
    pipes.add(Pipe('down', (start.$1 - 1, start.$2)));
  }
  if (map.length > start.$1 + 1 &&
      ['|', 'L', 'J'].contains(map[start.$1 + 1][start.$2])) {
    pipes.add(Pipe('up', (start.$1 + 1, start.$2)));
  }
  if (start.$2 > 1 && ['-', 'F', 'L'].contains(map[start.$1][start.$2 - 1])) {
    pipes.add(Pipe('right', (start.$1, start.$2 - 1)));
  }
  if (map[0].length > start.$2 + 1 &&
      ['-', 'J', '7'].contains(map[start.$1][start.$2 + 1])) {
    pipes.add(Pipe('left', (start.$1, start.$2 + 1)));
  }

  final totalPipes = <Pipe>{Pipe('Start', start)};
  totalPipes.addAll(pipes);

  while (pipes.first.coord != pipes.last.coord) {
    final newPipes = <Pipe>[];
    for (Pipe pipe in pipes) {
      newPipes.add(_getNext(pipe, map));
    }
    pipes = newPipes;
    totalPipes.addAll(newPipes);
  }

  return totalPipes;
}

Pipe _getNext(Pipe current, List<List<String>> map) {
  final coord = current.coord;
  var newFrom = '';
  var newCoord = (0, 0);
  switch (map[coord.$1][coord.$2]) {
    case '|':
      newFrom = current.from == 'up' ? 'up' : 'down';
    case '-':
      newFrom = current.from == 'left' ? 'left' : 'right';
    case 'L':
      newFrom = current.from == 'up' ? 'left' : 'down';
    case 'J':
      newFrom = current.from == 'up' ? 'right' : 'down';
    case '7':
      newFrom = current.from == 'down' ? 'right' : 'up';
    case 'F':
      newFrom = current.from == 'down' ? 'left' : 'up';
  }
  switch (newFrom) {
    case 'up':
      newCoord = (coord.$1 + 1, coord.$2);
    case 'down':
      newCoord = (coord.$1 - 1, coord.$2);
    case 'left':
      newCoord = (coord.$1, coord.$2 + 1);
    case 'right':
      newCoord = (coord.$1, coord.$2 - 1);
  }
  return Pipe(newFrom, newCoord);
}

class Pipe {
  const Pipe(this.from, this.coord);

  final String from;
  final (int y, int x) coord;
}

import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getTotalOfSmallestDirs;
  base.calculateSecond = _getMinimumDirSizeToDelete;
  base.exampleAnswerFirst = 95437;
  base.exampleAnswerSecond = 24933642;

  await base.calculate(7);
}

const int maxDirSize = 100000;
const int diskSpace = 70000000;
const int requiredFreeSpace = 30000000;

int _getTotalOfSmallestDirs(List<String> dataLines) {
  return _getDirSizes(dataLines)
      .where((int size) => size <= maxDirSize)
      .reduce((a, b) => a + b);
}

int _getMinimumDirSizeToDelete(List<String> dataLines) {
  final List<int> dirSizes = _getDirSizes(dataLines);
  final int spaceToFree = requiredFreeSpace - (diskSpace - dirSizes.last);
  return dirSizes.firstWhere((int size) => size >= spaceToFree);
}

List<int> _getDirSizes(List<String> dataLines) {
  final Dir fileTree = _getFileTree(dataLines);
  final List<int> dirSizes = <int>[];
  _addDirSizes(fileTree, dirSizes);
  dirSizes.sort();
  return dirSizes;
}

int _addDirSizes(Dir dir, List<int> allSizes) {
  int size = 0;
  for (Object item in dir.content) {
    if (item is File) {
      size += item.size;
    } else {
      size += _addDirSizes(item as Dir, allSizes);
    }
  }
  allSizes.add(size);
  return size;
}

Dir _getFileTree(List<String> dataLines) {
  final Dir mainDir = Dir('/', null);
  Dir currentDir = mainDir;
  for (int i = 0; i < dataLines.length; i++) {
    if (dataLines[i].startsWith('\$')) {
      String command = dataLines[i].substring(2);
      if (command == 'ls') {
        i++;
        while (i < dataLines.length) {
          String nextLine = dataLines[i];
          final List<String> contents = nextLine.split(' ');
          if (nextLine.startsWith('\$')) {
            command = nextLine.substring(2);
            break;
          } else if (nextLine.startsWith('dir')) {
            currentDir.content.add(Dir(contents.last, currentDir));
          } else {
            currentDir.content
                .add(File(contents.last, int.parse(contents.first)));
          }
          i++;
        }
      }
      if (command.startsWith('cd')) {
        if (command.endsWith('/')) {
          currentDir = mainDir;
        } else if (command.endsWith('..')) {
          currentDir = currentDir.parent!;
        } else {
          currentDir = currentDir.content.singleWhere((Object item) =>
              item is Dir && item.name == command.split(' ').last) as Dir;
        }
      }
    }
  }

  return mainDir;
}

class Dir {
  Dir(
    this.name,
    this.parent,
  );

  final String name;
  final Dir? parent;
  final List<Object> content = <Object>[];
}

class File {
  const File(
    this.name,
    this.size,
  );

  final String name;
  final int size;
}

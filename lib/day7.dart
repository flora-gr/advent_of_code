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
  final List<int> dirSizes = _getDirSizes(dataLines)..sort();
  final int spaceToFree = requiredFreeSpace - (diskSpace - dirSizes.last);
  return dirSizes.firstWhere((int size) => size >= spaceToFree);
}

List<int> _getDirSizes(List<String> dataLines) {
  final List<int> dirSizes = <int>[];
  _addDirSizes(_getFileTree(dataLines), dirSizes);
  return dirSizes;
}

int _addDirSizes(Dir dir, List<int> allSizes) {
  int size = 0;
  for (Object item in dir.contents) {
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
  for (String line in dataLines) {
    if (line.startsWith('\$ cd')) {
      final String newDir = line.split(' ').last;
      if (newDir == '/') {
        currentDir = mainDir;
      } else if (newDir == '..') {
        currentDir = currentDir.parent!;
      } else {
        currentDir = currentDir.contents.singleWhere(
            (Object item) => item is Dir && item.name == newDir) as Dir;
      }
    } else if (!line.startsWith('\$')) {
      final List<String> content = line.split(' ');
      if (content.first == 'dir') {
        currentDir.contents.add(Dir(content.last, currentDir));
      } else {
        currentDir.contents.add(File(content.last, int.parse(content.first)));
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
  final List<Object> contents = <Object>[];
}

class File {
  const File(
    this.name,
    this.size,
  );

  final String name;
  final int size;
}

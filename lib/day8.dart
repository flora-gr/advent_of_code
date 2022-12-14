import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getVisibleTreeCount;
  base.calculateSecond = _getMaxScenicScore;
  base.exampleAnswerFirst = 21;
  base.exampleAnswerSecond = 8;

  await base.calculate(8);
}

int _getVisibleTreeCount(List<String> dataLines) {
  final List<List<int>> treeMatrix = <List<int>>[];
  for (String line in dataLines) {
    treeMatrix
        .add(line.split('').map((String tree) => int.parse(tree)).toList());
  }

  final List<List<int>> treeMatrixTransposed = <List<int>>[];
  for (int i = 0; i < treeMatrix.length; i++) {
    treeMatrixTransposed
        .add(treeMatrix.map((List<int> row) => row[i]).toList());
  }

  int visibleTreeCount =
      2 * treeMatrix.length + 2 * treeMatrixTransposed.length - 4;
  for (int i = 1; i < treeMatrix.length - 1; i++) {
    for (int j = 1; j < treeMatrixTransposed.length - 1; j++) {
      final int currentTree = treeMatrix[i][j];

      final List<int> left = treeMatrix[i].sublist(0, j);
      final List<int> right = treeMatrix[i].sublist(j + 1);
      final List<int> top = treeMatrixTransposed[j].sublist(0, i);
      final List<int> bottom = treeMatrixTransposed[j].sublist(i + 1);

      if (left.every((int tree) => tree < currentTree) ||
          right.every((int tree) => tree < currentTree) ||
          top.every((int tree) => tree < currentTree) ||
          bottom.every((int tree) => tree < currentTree)) {
        visibleTreeCount++;
      }
    }
  }
  return visibleTreeCount;
}

int _getMaxScenicScore(List<String> dataLines) {
  final List<List<int>> treeMatrix = <List<int>>[];
  for (String line in dataLines) {
    treeMatrix
        .add(line.split('').map((String tree) => int.parse(tree)).toList());
  }

  final List<List<int>> treeMatrixTransposed = <List<int>>[];
  for (int i = 0; i < treeMatrix.length; i++) {
    treeMatrixTransposed
        .add(treeMatrix.map((List<int> row) => row[i]).toList());
  }

  int maxScenicScore = 0;
  for (int i = 1; i < treeMatrix.length - 1; i++) {
    for (int j = 1; j < treeMatrixTransposed.length - 1; j++) {
      final int currentTree = treeMatrix[i][j];

      final List<int> leftView =
          List<int>.from(treeMatrix[i].sublist(0, j).reversed);
      final List<int> rightView = treeMatrix[i].sublist(j + 1);
      final List<int> topView =
          List<int>.from(treeMatrixTransposed[j].sublist(0, i).reversed);
      final List<int> bottomView = treeMatrixTransposed[j].sublist(i + 1);

      final int leftNumber = _getNumberInView(currentTree, leftView);
      final int rightNumber = _getNumberInView(currentTree, rightView);
      final int topNumber = _getNumberInView(currentTree, topView);
      final int bottomNumber = _getNumberInView(currentTree, bottomView);

      final int scenicScore =
          leftNumber * rightNumber * topNumber * bottomNumber;
      if (scenicScore > maxScenicScore) {
        maxScenicScore = scenicScore;
      }
    }
  }
  return maxScenicScore;
}

int _getNumberInView(int currentTree, List<int> view) {
  if (view.any((int tree) => tree >= currentTree)) {
    return view.indexOf(view.firstWhere((int tree) => tree >= currentTree)) + 1;
  } else {
    return view.length;
  }
}

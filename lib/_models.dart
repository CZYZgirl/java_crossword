import 'package:flutter/material.dart';

class CrosswordModel {
  final int gridSize = 16;
  final List<List<String?>> crosswordGrid; // To store the letters
  final Map<int, String> hints; // To store hints for each word
  final Map<int, List<int>> wordPositions; // To store the positions of words
  final Map<int, int> wordLengths; // To store the length of each word
  final Map<int, bool> isHorizontal; // To store the orientation of each word
  final Set<int> _correctWords; // To track correct words
  final Map<int, String> words; // To store the actual words
  final Map<int, int> _wordNumbers; // To track the number for each word

  int _nextWordNumber = 1;

  CrosswordModel()
      : crosswordGrid = List.generate(
    16,
        (row) => List.generate(16, (col) => null),
  ),
        hints = {},
        wordPositions = {},
        wordLengths = {},
        isHorizontal = {},
        _correctWords = {},
        words = {},
        _wordNumbers = {} {
    addWord('JAVA', '명령행에서 자바 프로그램을 실행할 때 호출할 프로그램', 1, 0, true);  // Horizontal word
    addWord('ARRAYS', '‘무언가’를 여러개 집어 넣는 것', 1, 1, false);  // Vertical word
    addWord('BRANCH', '둘 다 할 수는 없음', 3, 0, true);  // Horizontal word
    addWord('WHILE', '조건 안에서 반복', 2, 5, false);  // Vertical word
    addWord('SYSTEMOUTPRINT', '무언가를 출력할 때 쓰는 것', 6, 1, true);  // Horizontal word
    addWord('STATIC', '특이한 변경자', 6, 3, false);  // Vertical word
    addWord('STRING', '문자 여러 개가 모여 있는 것', 9, 2, true);  // Horizontal word
    addWord('MAIN', '하나만 있어야 함', 6, 6, false);  // Vertical word
    addWord('INT', '숫자 변수 타입', 4, 5, true);  // Horizontal word
    addWord('FLOAT', '정수가 아닌 숫자 타입', 0, 7, false);  // Vertical word
    addWord('LOOP', '같은 내용을 반복시키는 것', 1, 7, true);  // Horizontal word
    addWord('VOID', '빈손으로 돌아옴', 0, 9, false);  // Vertical word
    addWord('DC', '노트북 전원의 약자', 3, 9, true);  // Horizontal word
    addWord('COMPILER', '소스 코드를 처리하는 것', 3, 10, false);  // Vertical word
    addWord('VARIABLE', '고정할 수 없음', 3, 12, false);  // Vertical word
    addWord('DECLARE', '새로운 클래스나 메서드가 있음을 알리는 것', 9, 9, true);  // Horizontal word
    addWord('COMMAND', '프롬프트를 사용하는 용도', 13, 9, true);  // Horizontal word
    addWord('METHOD', '어떤 일을 처리하게 해 주는 것', 8, 15, false);  // Vertical word
    addWord('PUBLIC', '공개된 것', 0, 15, false);  // Vertical word
    addWord('IC', '칩의 약자', 5, 14, true);  // Horizontal word
    addWord('JVM', '바이트코드를 처리하는 것', 11, 11, false);  // Vertical word
  }

  void addWord(String word, String hint, int startX, int startY, bool isHorizontal) {
    int wordNumber = _nextWordNumber++;
    hints[wordNumber] = hint;
    words[wordNumber] = word.toUpperCase();
    wordPositions[wordNumber] = [startX, startY];
    wordLengths[wordNumber] = word.length;
    this.isHorizontal[wordNumber] = isHorizontal;
    _wordNumbers[wordNumber] = wordNumber;

    // Calculate the end position of the word
    int endX = isHorizontal ? startX : startX + word.length - 1;
    int endY = isHorizontal ? startY + word.length - 1 : startY;

    // Check if the word fits within the grid
    if (endX >= gridSize || endY >= gridSize) {
      throw RangeError('Word "${word}" exceeds the grid boundaries.');
    }

    // Check if the word overlaps correctly
    for (int i = 0; i < word.length; i++) {
      int x = isHorizontal ? startX : startX + i;
      int y = isHorizontal ? startY + i : startY;
      if (crosswordGrid[x][y] != null && crosswordGrid[x][y] != word[i]) {
        throw ArgumentError('Conflict detected at position ($x, $y).');
      }
    }

    // Place the word on the grid
    for (int i = 0; i < word.length; i++) {
      int x = isHorizontal ? startX : startX + i;
      int y = isHorizontal ? startY + i : startY;
      crosswordGrid[x][y] = word[i];
    }
  }

  bool isWordCell(int x, int y) {
    for (var entry in wordPositions.entries) {
      List<int> pos = entry.value;
      int startX = pos[0];
      int startY = pos[1];
      int length = wordLengths[entry.key]!;
      bool isHorizontal = this.isHorizontal[entry.key]!;
      if (isHorizontal && startX == x && startY <= y && startY + length > y) {
        return true;
      }
      if (!isHorizontal && startY == y && startX <= x && startX + length > x) {
        return true;
      }
    }
    return false;
  }

  bool isWordCorrect(int wordNumber, String word) {
    return words[wordNumber]?.toUpperCase() == word.toUpperCase();
  }

  void setWordCorrect(int wordNumber, String word) {
    _correctWords.add(wordNumber);
    List<int> startPos = wordPositions[wordNumber]!;
    int length = wordLengths[wordNumber]!;
    bool isHorizontal = this.isHorizontal[wordNumber]!;
    for (int i = 0; i < length; i++) {
      int x = isHorizontal ? startPos[0] : startPos[0] + i;
      int y = isHorizontal ? startPos[1] + i : startPos[1];
      crosswordGrid[x][y] = word[i];
    }
  }

  bool isWordCompleted(int wordNumber) {
    return _correctWords.contains(wordNumber);
  }

  String? getHint(int wordNumber) {
    return hints[wordNumber];
  }

  int? getWordNumber(int x, int y) {
    for (var entry in wordPositions.entries) {
      List<int> pos = entry.value;
      int startX = pos[0];
      int startY = pos[1];
      int length = wordLengths[entry.key]!;
      bool isHorizontal = this.isHorizontal[entry.key]!;
      if (isHorizontal && startX == x && startY <= y && startY + length > y) {
        return entry.key;
      }
      if (!isHorizontal && startY == y && startX <= x && startX + length > x) {
        return entry.key;
      }
    }
    return null;
  }

  int? getWordStartingNumber(int x, int y) {
    for (var entry in wordPositions.entries) {
      List<int> pos = entry.value;
      int startX = pos[0];
      int startY = pos[1];
      if (startX == x && startY == y) {
        return _wordNumbers[entry.key];
      }
    }
    return null;
  }
}

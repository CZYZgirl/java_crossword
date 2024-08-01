import 'package:flutter/material.dart';
import 'models.dart';

class CrosswordPage extends StatefulWidget {
  @override
  _CrosswordPageState createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  final CrosswordModel _model = CrosswordModel();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode to manage focus
  String _hint = '';
  int? _currentX;
  int? _currentY;
  int? _currentWordNumber;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      // To handle focus changes if needed
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCellTap(int x, int y) {
    setState(() {
      _currentWordNumber = _model.getWordNumber(x, y);
      _currentX = x;
      _currentY = y;
      if (_currentWordNumber != null) {
        _hint = _model.getHint(_currentWordNumber!) ?? '';
        // Focus on the input field when a number cell is clicked
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        _hint = '';
      }
    });
  }

  void _updateCell(String value) {
    if (_currentX != null && _currentY != null) {
      setState(() {
        _model.crosswordGrid[_currentX!][_currentY!] = value;
      });
    }
  }

  void _checkAnswer() {
    if (_currentWordNumber != null) {
      String enteredWord = _controller.text.trim().toUpperCase();
      if (_model.isWordCorrect(_currentWordNumber!, enteredWord)) {
        _model.setWordCorrect(_currentWordNumber!, enteredWord);
        setState(() {
          _hint = '정답입니다!';
        });
      } else {
        setState(() {
          _hint = '다시 생각해보세요!';
        });
      }
      _controller.clear();
      _currentWordNumber = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JAVA Crossword'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _model.gridSize,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: _model.gridSize * _model.gridSize,
              itemBuilder: (context, index) {
                int x = index ~/ _model.gridSize;
                int y = index % _model.gridSize;
                bool isWordCell = _model.isWordCell(x, y);
                bool isCorrectWord = _model.isWordCompleted(_model.getWordNumber(x, y) ?? 0);
                int? wordNumber = _model.getWordStartingNumber(x, y);

                return GestureDetector(
                  onTap: () => _handleCellTap(x, y),
                  child: Container(
                    color: isWordCell
                        ? (isCorrectWord ? Colors.white : Colors.grey)
                        : Colors.black,
                    child: Center(
                      child: isWordCell
                          ? (isCorrectWord
                          ? Text(
                        _model.crosswordGrid[x][y] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                          : Text(
                        wordNumber != null && x == _model.wordPositions[wordNumber]![0] && y == _model.wordPositions[wordNumber]![1]
                            ? wordNumber.toString()
                            : '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                      )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode, // Attach FocusNode to the input field
              decoration: InputDecoration(
                labelText: '단어를 입력하세요',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _checkAnswer(); // Handle the submission when Enter is pressed
              },
            ),
          ),
          ElevatedButton(
            onPressed: _checkAnswer,
            child: Text('확인'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _hint,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

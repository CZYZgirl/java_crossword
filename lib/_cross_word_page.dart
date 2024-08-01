import 'package:flutter/material.dart';
import 'models.dart';

class CrosswordPage extends StatefulWidget {
  @override
  _CrosswordPageState createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  final CrosswordModel _model = CrosswordModel();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _hint = '';
  int? _currentX;
  int? _currentY;
  int? _currentWordNumber;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
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

        // focus on the input field when a number cell is clicked
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
          _hint = '정답! 👏🏻';
        });
      } else {
        setState(() {
          _hint = '다시 생각해보세요! 🤔';
        });
      }
      _controller.clear();
      _currentWordNumber = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400.0,
          height: 650.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                // round top
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Container(
                  width: 400.0,
                  height: 60.0,
                  color: Color(0XFFDAA38F),
                  child: Center(
                    child: Text(
                      'Java CrossWord',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
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
                        // cell color
                        color: isWordCell
                            ? (isCorrectWord ? Color(0XFFDAA38F) : Color(0XFFE9D7C0))
                            : Color(0XFF92ADA4),
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
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: '입력하세요',
                    labelStyle: TextStyle(
                      color: Color(0XFF92ADA4),
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFDAA38F), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFDAA38F), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFDAA38F), width: 2.0),
                    ),
                  ),
                  cursorColor: Color(0XFFDAA38F),
                  onSubmitted: (value) {
                    _checkAnswer();
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFDAA38F),
                  minimumSize: Size(150, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '정답 확인',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _hint,
                  style: TextStyle(fontSize: 16, color: Color(0XFF92ADA4),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

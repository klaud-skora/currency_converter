import 'dart:async';

class TextBloc {
  var _textController = StreamController<String>.broadcast();
  Stream<String> get textStream => _textController.stream;


  dispose() {
    _textController.close();
  }

  updateText(String text) {
    (text == null || text == "")
      ? _textController.sink.addError("Invalid value entered!")
      : _textController.sink.add(text);
  }
}
import 'dart:collection';

class RedoStack<T> {
  final _undoStack = Queue<T>();
  final _redoStack = Queue<T>();
  int limit = 20;

  RedoStack({required this.limit});

  int get undolength => _undoStack.length;

  int get redolength => _redoStack.length;

  bool canUndo() => _undoStack.isNotEmpty;

  bool canRedo() => _redoStack.isNotEmpty;

  void clearStack(){
    while(_undoStack.isNotEmpty){
      _undoStack.removeLast();
    }
    while(_redoStack.isNotEmpty){
      _redoStack.removeLast();
    }
  }
  void setLimit(int limit){
    if(limit>0)
      this.limit = limit;
  }

  void push(T element) {
    if(_undoStack.length==limit){
      _undoStack.removeFirst();
    }
    _undoStack.addLast(element);
  }

  T undo() {
    T lastElement = _undoStack.last;
    _undoStack.removeLast();

    if(_redoStack.length==limit){
      _redoStack.removeFirst();
    }
    _redoStack.addLast(lastElement);
    return lastElement;
  }

  T redo() {
    T lastElement = _redoStack.last;
    _redoStack.removeLast();
    if(_undoStack.length==limit){
      _undoStack.removeFirst();
    }
    _undoStack.addLast(lastElement);
    return lastElement;
  }


  T peak() => _undoStack.last;

}



import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'dart:math' as Math;

import 'RedoStack.dart';
import 'dart:io';

typedef EnterCallback = void Function();

class RedoTextEditController extends TextEditingController {
  late ValueChanged<RawKeyEvent> keyListener;
  late RedoStack<String> copyStack;
  Set<String> pressKey = new HashSet();
  int lastSelection = 0;
  var forcusNode = FocusNode();
  EnterCallback? enterCallback;
  VoidCallback? listener;


  /**
   * undolimit  undo stack max size
   */
  void initState({int undolimit=20}){
    copyStack = RedoStack<String>(limit:undolimit);
    keyListener = (value){
      _handleKeyDown(value);
    };
    listener=() {
        if(isMetaleft()){
          // textController.text = copyStack.peak();
        }else{
          if(value.composing.start==-1){
            if(copyStack.undolength==0||text!=copyStack.peak()){
              copyStack.push(text);
              lastSelection =selection.base.offset;
            }
          }
        }
    };
    this.addListener(listener!);

    forcusNode.addListener(() {
      if(forcusNode.hasFocus){
        RawKeyboard.instance.removeListener(keyListener);
        RawKeyboard.instance.addListener(keyListener);
      }else{
        RawKeyboard.instance.removeListener(keyListener);
      }
    });

  }

  void addEnterClickListener(EnterCallback listener) {
      this.enterCallback = listener;
  }

  void _handleKeyDown(RawKeyEvent value) {
    if (value is RawKeyDownEvent) {
      final k = value.logicalKey.keyLabel;
      if (k == LogicalKeyboardKey.enter.keyLabel) {
        enterCallback?.call();
      }else if(k==LogicalKeyboardKey.keyZ.keyLabel){
        if(isMetaleft()){
          if(pressKey.contains(LogicalKeyboardKey.shiftLeft.keyLabel)){
             redo();
          }else{
             undo();
          }

        }
      }else if(k==LogicalKeyboardKey.keyS.keyLabel){
        if(pressKey.contains(LogicalKeyboardKey.metaLeft)){
        }
      }
      pressKey.add(k);
    }else if(value is RawKeyUpEvent){
      final k = value.logicalKey;
      pressKey.remove(k.keyLabel);
    }
  }

  void redo(){
    if(copyStack.canRedo()){
      text=copyStack.redo();
      selection = TextSelection.fromPosition(TextPosition(offset: Math.min(text.length,lastSelection)));
    }
  }

  void undo(){
    if(copyStack.canUndo()){
      copyStack.undo();
      if(copyStack.undolength>0){
        text = copyStack.peak();
        selection = TextSelection.fromPosition(TextPosition(offset: Math.min(text.length,lastSelection)));
      }

    }
  }
  @override
  void dispose() {
    super.dispose();
    if(listener!=null)
      removeListener(listener!);
  }

  bool isMetaleft(){
    return (Platform.isMacOS&&pressKey.contains(LogicalKeyboardKey.metaLeft.keyLabel))
        ||(Platform.isWindows&&pressKey.contains(LogicalKeyboardKey.controlLeft.keyLabel));
  }

}

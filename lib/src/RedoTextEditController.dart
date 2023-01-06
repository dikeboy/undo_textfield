

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

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

  RedoTextEditController({ int undolimit=20 }){
    copyStack = RedoStack<String>(limit:undolimit);
    keyListener = (value){
      _handleKeyDown(value);
    };
    listener=() {
      if(isMetaleft()){
        // textController.text = copyStack.peak();
      }else{
        // print("sel = ${value.isComposingRangeValid}");
        // print("start = ${value.composing.start}  end = ${value.composing.end}");
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

  /**
   * undolimit  undo stack max size
   */
  void initState({int undolimit=20}){


  }

  @override
  void addListener(VoidCallback listener) {
    if(listener.toString().contains("_push")){
      return;
    }
    if(kIsWeb){
      if(StackTrace.current.toString().contains("editable_text.dart 4")){
        return;
      }
    }
    super.addListener(listener);
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
    return (TargetPlatform.macOS==defaultTargetPlatform&&pressKey.contains(LogicalKeyboardKey.metaLeft.keyLabel))
        ||(TargetPlatform.windows==defaultTargetPlatform&&pressKey.contains(LogicalKeyboardKey.controlLeft.keyLabel));
  }


  @override
  set value(TextEditingValue newValue) {
    super.value = newValue;
  }

  @override
  void userUpdateTextEditingValue(TextEditingValue value, SelectionChangedCause? cause) {

  }
}

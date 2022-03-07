A flutter plugin for textfield undo or redo,  for. mac windows or linux

* [How to install](https://pub.dev/packages/undo_textfield)

```javascript
  var urlController = RedoTextEditController();
  Widget getChild(){
    return TextField(
      controller: urlController,
      focusNode: urlController.forcusNode,
    );
  }

```

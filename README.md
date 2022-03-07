A flutter plugin for textfield undo or redo,  for. mac windows or linux


```javascript
  var urlController = RedoTextEditController();
  Widget getChild(){
    return TextField(
      controller: urlController,
      focusNode: urlController.forcusNode,
    );
  }

```

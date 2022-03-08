A flutter plugin for textfield undo or redo,  for. mac windows or linux

Flutter desktop textfield  undo or redo

For mac.  metaleft+z. and. metaleft+shiftLeft+z
For win.  ctrlLeft+z. and ctrlLeft+shiftLeft+z

* [How to install](https://pub.dev/packages/undo_textfield)



```javascript

  var urlController = RedoTextEditController();
  
  @override
  void initState() {
    super.initState();
    urlController.initState();

  }
  
  Widget getChild(){
    return TextField(
      controller: urlController,
      focusNode: urlController.forcusNode,
    );
  }

```

import 'package:flutter/material.dart';

class DisplayTextTile extends StatefulWidget {
  final String input;
  final VoidCallback clearText;
  final Function(String) emitName;

  const DisplayTextTile({
    Key? key,
    required this.input,
    required this.clearText,
    required this.emitName,
  }) : super(key: key);

  @override
  _DisplayTextTileState createState() => _DisplayTextTileState();
}

class _DisplayTextTileState extends State<DisplayTextTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(widget.input),
        GestureDetector(
          onTap: () {
            _clearValue();
          },
          child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            color: Colors.redAccent,
            child: Text("Clear Text"),
          ),
        ),
        GestureDetector(
          onTap: () {
            _emitName();
          },
          child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            color: Colors.redAccent,
            child: Text("Display Name"),
          ),
        ),
      ],
    ));
  }

  _clearValue() {
    widget.clearText();
  }

  _emitName() {
    widget.emitName("Hello World");
  }
}

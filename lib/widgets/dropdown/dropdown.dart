import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dropdown extends StatefulWidget {
  final String? selectedEnterprise;
  final bool isOpen;

  const Dropdown({
    Key? key,
    this.selectedEnterprise = "Select an enterprise",
    this.isOpen = false,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return _selectTextfield();
  }

  Widget _selectTextfield() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          _icon(),
          _text(),
          _arrow(),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 241, 241, 241),
          width: 3.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      height: 75.0,
      width: 350.0,
    );
  }

  Widget _icon() {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/images/dropdown_icon.svg',
        fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      height: 20.0,
      width: 20.0,
    );
  }

  Widget _arrow() {
    return Transform.rotate(
        angle: widget.isOpen ? 180 * math.pi / 180 : 0,
        child: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/images/dropdown_arrow.svg',
            fit: BoxFit.contain,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          height: 20.0,
          width: 25.0,
        ));
  }

  Widget _text() {
    return Expanded(
      child: Container(
        child: Text(
          widget.selectedEnterprise ?? "Select an enterprise",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Neutrif Pro',
            fontSize: 15.0,
            height: 1.0,
          ),
          textAlign: TextAlign.left,
        ),
        margin: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
      ),
    );
  }
}

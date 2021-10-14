import 'package:flutter/material.dart';
import 'package:state_management/models/ehpgstatus.dart';

class CustomSlider extends StatefulWidget {
  final int? initialValue;
  final String leftText;
  final String rightText;
  final Function(int) onSliderClick;

  const CustomSlider(
      {Key? key,
      this.initialValue,
      required this.leftText,
      required this.rightText,
      required this.onSliderClick})
      : super(key: key);

  @override
  _CustomSliderState createState() => new _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider>
    with AutomaticKeepAliveClientMixin {
  int _state = EhpgState.YES.index;
  double _heightRatio = 1.0;
  double _widthRatio = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 328.0 * _widthRatio,
        height: 75.0 * _heightRatio,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              width: 3.0 * _widthRatio, color: const Color(0xffffaeae)),
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              width: 170.0 * _widthRatio,
              height: 75 * _heightRatio,
              left: _state == EhpgState.YES.index ? 0 : 155 * _widthRatio,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x80fa3030),
                      offset: Offset(0, 20),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 160.0 * _widthRatio,
                  height: 75 * _heightRatio,
                  padding: EdgeInsets.only(
                      left: 15 * _widthRatio, right: 10 * _widthRatio),
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: _state == EhpgState.YES.index
                        ? TextStyle(
                            color: const Color(0xff000000),
                          )
                        : TextStyle(
                            color: Colors.redAccent,
                          ),
                    child: Text(
                      widget.leftText,
                      style: TextStyle(
                        fontFamily: 'Neutrif Pro',
                        fontSize: 15 * _widthRatio,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 160 * _widthRatio,
                  height: 75 * _heightRatio,
                  padding: EdgeInsets.only(
                      left: 10 * _widthRatio, right: 15 * _widthRatio),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: _state == EhpgState.NO.index
                        ? TextStyle(
                            color: const Color(0xff000000),
                          )
                        : TextStyle(
                            color: Colors.redAccent,
                          ),
                    child: Text(
                      widget.rightText,
                      style: TextStyle(
                        fontFamily: 'Neutrif Pro',
                        fontSize: 15 * _widthRatio,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: onTapSlider,
    );
  }

  @override
  void initState() {
    super.initState();
    _state = widget.initialValue ?? EhpgState.YES.index;
  }

  @override
  bool get wantKeepAlive => true;

  onTapSlider() {
    setState(() {
      if (_state == EhpgState.NO.index) {
        _state = EhpgState.YES.index;
      } else {
        _state = EhpgState.NO.index;
      }
    });
    widget.onSliderClick(_state);
  }
}

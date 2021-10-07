import 'dart:async';

import 'package:flutter/material.dart';
import 'package:state_management/models/enterprise.dart';

import 'dropdown.dart';

class DropdownPopup extends StatefulWidget {
  final Offset position;
  final VoidCallback tapCallBack;
  final Function(Enterprise) onSelectEnterprise;
  final Enterprise? selectedEnterprise;
  final List<Enterprise> list;

  const DropdownPopup({
    Key? key,
    required this.position,
    required this.tapCallBack,
    this.selectedEnterprise,
    required this.list,
    required this.onSelectEnterprise,
  }) : super(key: key);

  @override
  _DropdownPopupState createState() => _DropdownPopupState();
}

class _DropdownPopupState extends State<DropdownPopup> {
  final ScrollController _scrollController = ScrollController();
  Color? _colorOnHover = const Color.fromRGBO(0, 0, 0, 0.05);
  int? _selectedEnterpriseId;

  @override
  void initState() {
    super.initState();
    if (widget.selectedEnterprise != null) {
      setState(() {
        _selectedEnterpriseId = widget.selectedEnterprise!.id;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeDropdown,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.5),
        ),
        child: Stack(
          children: [
            Positioned(
              left: widget.position.dx,
              top: widget.position.dy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _closeDropdown();
                    },
                    child: Dropdown(
                      selectedEnterprise: widget.selectedEnterprise?.name,
                      isOpen: true,
                    ),
                  ),
                  Container(
                    width: 350.0,
                    height: 350.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    padding: EdgeInsets.only(
                      bottom: 20.0,
                      top: 20.0,
                    ),
                    child: MediaQuery.removePadding(
                      //to remove unnecessary top padding in ScrollBar
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          itemCount: widget.list.length,
                          itemBuilder: (context, index) {
                            return _getListItem(widget.list[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListItem(Enterprise item) {
    return InkWell(
      onTap: () {
        _selectItem(item);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
            color: _selectedEnterpriseId == item.id
                ? _colorOnHover
                : Colors.white),
        child: Text(
          item.name,
          style: TextStyle(
            color: Colors.black.withOpacity(0.50),
            fontSize: 15.0,
            fontFamily: 'Neutrif Pro',
          ),
        ),
        margin: EdgeInsets.only(
          left: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 15,
        ),
      ),
    );
  }

  // Close dropdown
  _closeDropdown() {
    widget.tapCallBack();
  }

  // Select item in the list
  _selectItem(Enterprise item) {
    setState(() {
      _selectedEnterpriseId = item.id;
    });

    Timer(const Duration(milliseconds: 300), () {
      widget.onSelectEnterprise(item);
    });
  }
}

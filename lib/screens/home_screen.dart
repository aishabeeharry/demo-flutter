import 'package:flutter/material.dart';
import 'package:state_management/models/enterprise.dart';
import 'package:state_management/widgets/display_text_tile.dart';

import '../widgets/dropdown/dropdown.dart';
import '../widgets/dropdown/dropdown_popup.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _input = "";
  OverlayEntry? _overlayEntry;
  final GlobalKey _dropdownKey = GlobalKey();

  List<Enterprise> _enterpriseList = [
    new Enterprise(0, 'Actemium'),
    new Enterprise(1, 'Omexon'),
    new Enterprise(2, 'SIMA - Vinci Energies'),
    new Enterprise(3, 'Lorem lpsum'),
    new Enterprise(4, 'Dolor est'),
    new Enterprise(5, 'Consecteur adipiscing'),
    new Enterprise(6, 'Phasellus'),
    new Enterprise(7, 'Imperdiet'),
  ];

  Enterprise? _selectedEnterprise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(32, 72, 159, 1.0),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _displayValue();
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      color: Colors.redAccent,
                      child: Text("Display Value"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: DisplayTextTile(
                  input: _input,
                  clearText: () {
                    print("CLEAR TEXT");
                    _textEditingController.clear();
                    setState(() {
                      _input = "";
                    });
                  },
                  emitName: (String name) {
                    print("Name " + name);
                    _textEditingController.text = name;
                    setState(() {
                      _input = name;
                    });
                  },
                ),
              ),

              // ----------------- Dropdown --------------------------------------
              Container(
                child: GestureDetector(
                  onTap: _openDropdown,
                  child: Container(
                    key: _dropdownKey,
                    child: Dropdown(
                      selectedEnterprise: _selectedEnterprise?.name,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openDropdown() {
    this._overlayEntry = this._createOverlayEntry();

    //Add OverlayEntry to Overlay Widget
    Overlay.of(context)!.insert(this._overlayEntry!);
  }

  // Add Dropdown Popup in an OverlayEntry Widget
  OverlayEntry _createOverlayEntry() {
    // Get Offset(x & y coordinates) of Container attached to GlobalKey _dropdownKey
    RenderBox _dropdownBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Offset _dropdownPosition = _dropdownBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: DropdownPopup(
            position: _dropdownPosition,
            tapCallBack: _closeDropdown,
            list: _enterpriseList,
            onSelectEnterprise: (Enterprise enterprise) {
              _onSelectEnterprise(enterprise);
            },
            selectedEnterprise: _selectedEnterprise,
          ),
        ),
      ),
    );
  }

  // Remove overlay Entry which will automatically remove the DropdownPopup widget as well
  _closeDropdown() {
    if (this._overlayEntry != null) {
      this._overlayEntry!.remove();
    }
  }

  // Set selected Enterprise when dropdown is closed
  _onSelectEnterprise(Enterprise enterprise) {
    setState(() {
      _selectedEnterprise = enterprise;
      _closeDropdown();
    });
  }

  _displayValue() {
    setState(() {
      _input = _textEditingController.text;
    });
  }
}

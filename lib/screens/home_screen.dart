import 'dart:async';

import 'package:flutter/material.dart';
import 'package:state_management/bloc/trip_bloc.dart';
import 'package:state_management/models/ehpgstatus.dart';
import 'package:state_management/models/enterprise.dart';
import 'package:state_management/models/trip.dart';
import 'package:state_management/widgets/display_text_tile.dart';
import 'package:state_management/widgets/slider.dart';

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
  StreamSubscription? _subscription;
  int _ehpg = EhpgState.NO.index;

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
  List<Trip>? _trips;

  @override
  void initState() {
    super.initState();
    tripBloc.getTripList();
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayoutInit);
//    _subscription = tripBloc.tripListPublishSubject.stream.listen((event) {
//      if (event != null) {
//        _trips = event;
//      }
//    });
  }

  void _afterLayoutInit(_) async {
    if (mounted) {
      _subscription = tripBloc.tripListPublishSubject.stream.listen((event) {
        if (event != null) {
          _trips = event;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              Center(
                child: CustomSlider(
                    leftText: "Yes",
                    rightText: "No",
                    initialValue: _ehpg,
                    onSliderClick: _handleSliderChange),
              ),

              // ----------------- BLOC ------------------------------------------

              // ----------------- Using Stream Builder ------------------------------------------
              Container(
                padding: EdgeInsets.all(25.0),
                child: StreamBuilder(
                  stream: tripBloc.tripListPublishSubject,
                  builder: (context, AsyncSnapshot<List<Trip>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(child: _buildList(snapshot.data));
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),

              // ---------------- Using stream subscription ------------------------
//              Container(
//                padding: EdgeInsets.all(25.0),
//                child: (_trips != null && _trips!.length > 0)
//                    ? _buildList(_trips)
//                    : CircularProgressIndicator(),
//              ),
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

  Widget _buildList(List<Trip>? data) {
    return ListView.builder(
        itemCount: data!.length,
        shrinkWrap: true,
        itemBuilder: (context, pos) {
//          return ListTile(
//            title: Text(data[pos].name),
//            subtitle: Text(data[pos].date),
//          );
          return ExpansionTile(
            title: Text(
              data[pos].name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              data[pos].date,
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
            ),
            children: <Widget>[
              data[pos].expenses != null && data[pos].expenses!.length > 0
                  ? ListView.builder(
                      itemCount: data[pos].expenses!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            data[pos].expenses![index].merchantName ?? '',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            data[pos].expenses![index].merchantAddress ?? '',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        );
                      })
                  : Container()
            ],
          );
        });
  }

  void _handleSliderChange(int state) {
    setState(() {
      _ehpg = state;
    });
  }
}

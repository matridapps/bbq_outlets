import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:flutter/material.dart';
Widget myBottomNav(int _selectedIndex, List<BottomNavigationBarItem> btmItem,
    _itemTaped(int value)) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: _selectedIndex,
    items: ConstantsVar.btmItem,
    onTap: _itemTaped,
  );
}

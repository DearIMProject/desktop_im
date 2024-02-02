import 'package:flutter/material.dart';

class BottomTabbarItem {
  late String title;
  late IconData icon;
  bool isSelected = false;
  int badgeNumber = 0;

  BottomTabbarItem(this.title, this.icon, this.isSelected, this.badgeNumber);
}

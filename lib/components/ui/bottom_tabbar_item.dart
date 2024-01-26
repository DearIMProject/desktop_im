import 'package:flutter/material.dart';

class BottomTabbarItem {
  late String title;
  late IconData icon;
  bool isSelected = false;

  BottomTabbarItem(this.title, this.icon, this.isSelected);
}

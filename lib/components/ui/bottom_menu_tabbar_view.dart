import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/components/ui/bottom_tabbar_item.dart';
import 'package:flutter/material.dart';

typedef BottomController = void Function(int selectIndex);

class BottomMenuTabbarViewPage extends Listenable {
  int currentIndex = 0;
  List<VoidCallback> listeners = [];
  @override
  void addListener(VoidCallback listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listeners.remove(listener);
  }
}

// ignore: must_be_immutable
class BottomMenuTabbarView extends StatefulWidget {
  final List<BottomTabbarItem> tabbarItems;
  final BottomController bottomDelegate;
  BottomMenuTabbarViewPage? controller;
  int selectedIndex = 0;
  BottomMenuTabbarView(
      {super.key,
      required this.tabbarItems,
      required this.bottomDelegate,
      required this.selectedIndex,
      this.controller});

  @override
  State<BottomMenuTabbarView> createState() => _BottomMenuTabbarViewState();
}

class _BottomMenuTabbarViewState extends State<BottomMenuTabbarView> {
  List<Widget> children() {
    List<Widget> result = [];
    for (var i = 0; i < widget.tabbarItems.length; i++) {
      BottomTabbarItem element = widget.tabbarItems[i];
      var awidget = OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          side: const BorderSide(width: 0, color: Colors.transparent),
        ),
        onPressed: () {
          if (widget.selectedIndex == i) {
            return;
          }
          BottomTabbarItem lastItem = widget.tabbarItems[widget.selectedIndex];
          lastItem.isSelected = false;
          element.isSelected = true;
          widget.selectedIndex = i;
          widget.bottomDelegate(i);
          widget.controller?.currentIndex = widget.selectedIndex;
          setState(() {});
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width /
                (widget.tabbarItems.length + 2),
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    color: element.isSelected ? kThemeColor : kTitleColor,
                    element.icon),
                !element.isSelected
                    ? littleTitleFontText(kTitleColor, element.title)
                    : littleTitleFontText(kThemeColor, element.title)
              ],
            )),
      );
      result.add(awidget);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children(),
      ),
    ));
  }
}

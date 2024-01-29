import 'package:flutter/material.dart';

const double kSpace = 16;

SizedBox widthSpaceSizeBox = const SizedBox(
  width: kSpace,
);

SizedBox itemSpaceSizeBox = const SizedBox(
  width: kSpace * 0.5,
);
ClipRRect radiusBorder(Widget widget) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: widget,
  );
}

Padding pagePadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(kSpace, 0, kSpace, 0),
    child: widget,
  );
}

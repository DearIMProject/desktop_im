import 'package:flutter/material.dart';

SizedBox widthSpaceSizeBox = const SizedBox(
  width: 16,
);

ClipRRect radiusBorder(Widget widget) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: widget,
  );
}

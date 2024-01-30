import 'package:flutter/material.dart';

const double kSpace = 16;

SizedBox widthSpaceSizeBox = const SizedBox(
  width: kSpace,
);

SizedBox itemSpaceWidthSizeBox = const SizedBox(
  width: kSpace * 0.5,
);
SizedBox itemSpaceHeightSizeBox = const SizedBox(
  height: kSpace * 0.5,
);
ClipRRect radiusBorder(Widget widget) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: widget,
  );
}

ClipRRect radiusCustomBorder(Widget widget, double radius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: widget,
  );
}

Padding pagePadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(kSpace, 0, kSpace, 0),
    child: widget,
  );
}

Padding itemPadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, kSpace * 0.5, 0, kSpace * 0.5),
    child: widget,
  );
}

Padding roundItemPadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(
        kSpace * 0.5, kSpace * 0.5, kSpace * 0.5, kSpace * 0.5),
    child: widget,
  );
}

Flexible maxWidthWidget(Widget widget, double maxWidth) {
  return Flexible(
    flex: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: widget,
    ),
  );
}

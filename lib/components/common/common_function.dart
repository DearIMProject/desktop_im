import 'package:cached_network_image/cached_network_image.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:flutter/material.dart';

CachedNetworkImage networkImage(String imageSrc, double width, double height) {
  return CachedNetworkImage(
    imageUrl: imageSrc,
    fit: BoxFit.cover,
    width: width,
    height: height,
    errorWidget: (context, error, stackTrace) {
      return SizedBox(
        width: width,
        height: height,
        child: Text(
          S.current.fail_to_load_image,
          style: const TextStyle(fontSize: 18),
        ),
      );
    },
    progressIndicatorBuilder: (context, url, progress) => Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: progress.progress,
        ),
      ),
    ),
  );
}

CachedNetworkImage networkImageFitHeight(
  String imageSrc,
  double width,
) {
  return CachedNetworkImage(
    imageUrl: imageSrc,
    fit: BoxFit.fitHeight,
    width: width,
    errorWidget: (context, url, error) {
      return SizedBox(
        width: width,
        child: Text(
          S.current.fail_to_load_image,
          style: const TextStyle(fontSize: 18),
        ),
      );
    },
    progressIndicatorBuilder: (context, url, progress) {
      return Center(
        child: SizedBox(
          width: width,
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
      );
    },
  );
}

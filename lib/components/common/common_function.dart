import 'package:desktop_im/generated/l10n.dart';
import 'package:flutter/material.dart';

Image networkImage(String imageSrc, double width, double height) {
  return Image.network(
    imageSrc,
    fit: BoxFit.cover,
    width: width,
    height: height,
    errorBuilder: (context, error, stackTrace) {
      return Text(
        S.current.fail_to_load_image,
        style: const TextStyle(fontSize: 18),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        ),
      );
    },
  );
}

Image networkImageFitHeight(
  String imageSrc,
  double width,
) {
  return Image.network(
    imageSrc,
    fit: BoxFit.fitHeight,
    width: width,
    errorBuilder: (context, error, stackTrace) {
      return Text(
        S.current.fail_to_load_image,
        style: const TextStyle(fontSize: 18),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: SizedBox(
          width: width,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        ),
      );
    },
  );
}

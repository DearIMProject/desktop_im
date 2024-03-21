import 'dart:io';

import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:flutter/material.dart';

class LoadingImage extends StatefulWidget {
  bool showLoading;
  double? width;
  double? height;
  String imageSrc;
  LoadingImage(
      {super.key,
      required this.showLoading,
      this.width,
      this.height,
      required this.imageSrc});

  @override
  State<LoadingImage> createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  File? fileImage;

  @override
  Widget build(BuildContext context) {
    fileImage ??= File(widget.imageSrc);
    bool isFile = fileImage != null && fileImage!.existsSync();
    Log.debug("isFile = $isFile");
    return !isFile
        ? networkImage(widget.imageSrc, widget.width!.toDouble(),
            widget.height!.toDouble())
        : Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.file(
                fileImage!,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.fitHeight,
              ),
              Visibility(
                visible: widget.showLoading,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  color: const Color.fromARGB(227, 60, 59, 57),
                  child: const Center(
                      child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )),
                ),
              ),
            ],
          );
  }
}

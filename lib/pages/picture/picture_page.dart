import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/loading_image.dart';
import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/models/fileBean.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:flutter/material.dart';

class PicturePage extends BasePage {
  const PicturePage({super.key, super.params});

  @override
  State<PicturePage> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  FileBean? fileBean;
  @override
  void initState() {
    super.initState();
    fileBean = widget.params?["fileBean"];
  }

  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      showLoading: true,
      imageSrc: fileBean!.filePath,
      width: fileBean!.width.toDouble(),
      height: fileBean!.height.toDouble(),
    );
  }
}

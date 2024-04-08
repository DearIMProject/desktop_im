import 'dart:async';

import 'package:camera/camera.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:flutter/material.dart';

class IMCameraPage extends BasePage {
  const IMCameraPage({super.key, super.params});

  @override
  State<IMCameraPage> createState() => IMCameraPageState();
}

class IMCameraPageState extends State<IMCameraPage> {
  List<CameraDescription> _cameras = [];
  late CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> initialize() {
    Completer completer = Completer();
    availableCameras().then((value) {
      _cameras.addAll(value);
      _cameraController = CameraController(_cameras[0], ResolutionPreset.medium,
          enableAudio: false);
      _cameraController?.initialize().then((_) {
        completer.complete();
      });
    });

    return completer.future;
  }

  bool isLightOn = false;
  double iconSize = 30;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Log.debug("done!");
            // If the Future is complete, display the preview.
            return Column(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.red,
                  // height: double.infinity,
                )),
                SafeArea(
                    top: false,
                    bottom: true,
                    child: Container(
                      // color: Colors.amber,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              updateLightingStatus();
                            },
                            child: Icon(
                              isLightOn ? Icons.flash_on : Icons.flash_off,
                              color: kWhiteBackColor,
                              size: iconSize,
                            ),
                          ),
                          widthSpaceSizeBox,
                          widthSpaceSizeBox,
                          GestureDetector(
                            onTap: () {
                              onClickTakePhoto();
                            },
                            child: const Icon(
                              Icons.circle,
                              color: kWhiteBackColor,
                              size: 80,
                            ),
                          ),
                          widthSpaceSizeBox,
                          widthSpaceSizeBox,
                          Icon(
                            Icons.change_circle_outlined,
                            color: kWhiteBackColor,
                          )
                        ],
                      ),
                    )),
              ],
            );
          } else {
            Log.debug("no!");
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void onClickTakePhoto() {
    // 拍照
  }

  void updateLightingStatus() {
    isLightOn = !isLightOn;
    setState(() {});
  }
}

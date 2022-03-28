import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:after_layout/after_layout.dart';
import 'package:camera/camera.dart';
import 'package:my_gym_lifts/screens/video_editor_screen.dart';
import 'package:intl/intl.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.audioHasPermission, required this.appDocsDir}) : super(key: key);

  final bool audioHasPermission;

  final Directory appDocsDir;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> with RouteAware, AfterLayoutMixin<CameraScreen>, TickerProviderStateMixin, WidgetsBindingObserver {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> cameraScreenScaffoldKey = GlobalKey<ScaffoldState>();

  CameraController? camController;
  List? cameras;
  int? selectedCameraIdx;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;

  bool recording = false;
  Stopwatch timeCounter = Stopwatch();

  String? videoPath;

  bool showRecordingBorder = true;
  Timer? recordingAnimationTimer;

  /// Init State
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
        });
        initCameraController(cameras![selectedCameraIdx ?? 0]).then((void v) {});
      }
      else{
//        print("No camera available");
      }
    }).catchError((err) {
//      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future initCameraController(CameraDescription cameraDescription) async {
    if (camController != null) {
      await camController!.dispose();
    }

    camController = CameraController(cameraDescription, ResolutionPreset.high);

    camController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (camController!.value.hasError) {
//        print('Camera error ${camController!.value.errorDescription}');
      }
    });

    try {
      await camController!.initialize();
    } on CameraException { //catch (e) {
//      print(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Did Change Dependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObserver<PageRoute>().subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  /// Dispose
  @override
  void dispose() {
    RouteObserver<PageRoute>().unsubscribe(this);
    WidgetsBinding.instance!.removeObserver(this);
    if (recordingAnimationTimer != null) {
      recordingAnimationTimer!.cancel();
    }
    if (camController != null) {
      camController!.dispose();
    }
    if (timeCounter.isRunning) {
      timeCounter.stop();
    }
    super.dispose();
  }

  /// After First Layout
  @override
  void afterFirstLayout(BuildContext context) {

  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Get Full Screen Width and Height
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;

    /// Safe Areas Padding
    final double topSafeArea = MediaQuery.of(context).padding.top;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;

    /// Screen orientation variables.
//    var orientation = MediaQuery.of(context).orientation;
//    var onPortrait = (orientation == Orientation.portrait);

    /// Camera Container
    var cameraContainer = Positioned( //TODO: CHANGE CONTAINER TO LOADER
      child: (camController == null || !camController!.value.isInitialized) ? Container() : Stack(
        children: [
          GestureDetector(
            /// IF ERROR, THE ! is the issue
            child: CameraPreview(camController!),
            onDoubleTap: () => switchCamera(),
          ),
        ],
        alignment: Alignment.center,
      ),
      top: (topSafeArea),
      bottom: (bottomSafeArea),
    );

    /// Close Button
    var closeButtonContainer = SizedBox(
      child: AnimatedOpacity(
        child: ElevatedButton(
          child: const Icon(
            Icons.close,
            size: 20.0,
            color: whiteColor,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: lightBlueColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
            elevation: 0.0,
            padding: const EdgeInsets.all(0.0),
          ),
          onPressed: () {
            if (camController!.value.isRecordingVideo == false) {
              if (recordingAnimationTimer != null) {
                recordingAnimationTimer!.cancel();
              }
              if (camController != null) {
                camController!.dispose();
              }
              if (timeCounter.isRunning) {
                timeCounter.stop();
              }
              timeCounter.reset();

              Navigator.pop(context);
            }
          },
        ),
        opacity: camController!.value.isRecordingVideo ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutExpo,
      ),
      width: 50.0,
      height: 50.0,
    );

    /// Print Duration
    String printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    /// Time Container
    var timeContainer = Expanded(
      child: Container(
        child: Text(
          camController!.value.isRecordingVideo ? printDuration(Duration(milliseconds: timeCounter.elapsedMilliseconds)) : "00:00:00",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: regularWeight,
            fontSize: regularFontSize,
            color: whiteColor,
            decoration: TextDecoration.none,
          ),
        ),
        alignment: Alignment.center,
      ),
    );

    /// Flip Camera Button Container
    var flipCameraButtonContainer = SizedBox(
      child: AnimatedOpacity(
        child: ElevatedButton(
          child: const Icon(
            Icons.flip_camera_ios_rounded,
            size: 24.0,
            color: whiteColor,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: lightBlueColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
            elevation: 0.0,
            padding: const EdgeInsets.all(0.0),
          ),
          onPressed: () => switchCamera(),
        ),
        opacity: camController!.value.isRecordingVideo ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutExpo,
      ),
      width: 50.0,
      height: 50.0,
    );

    /// Top Container
    var topContainer = Positioned(
      child: Container(
        decoration: const BoxDecoration(
          color: blackColor,
        ),
        child: Row(
          children: [
            closeButtonContainer,
            timeContainer,
            flipCameraButtonContainer,
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        padding: EdgeInsets.only(top: topSafeArea),
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      height: (topSafeArea + 50.0),
    );

    /// Record Button Container
    var recordButtonContainer = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: whiteColor, width: 4.0),
      ),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [darkRedColor, lightRedColor],
          ),
          borderRadius: camController!.value.isRecordingVideo ? BorderRadius.circular(8.0) : BorderRadius.circular(80.0),
        ),
        child: ElevatedButton(
          child: Container(),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: blackColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            elevation: 0.0,
            padding: const EdgeInsets.all(0.0),
          ),
//          onPressed: () => getMusicPlaybackState(),
          onPressed: () => (camController!.value.isRecordingVideo ? onStopButtonPressed() : onVideoRecordButtonPressed()),
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        margin: camController!.value.isRecordingVideo ? const EdgeInsets.all(8.0) : const EdgeInsets.all(0.0),
      ),
      padding: const EdgeInsets.all(4.0),
      height: 65.0,
      width: 65.0,
    );

    /// Bottom Container
    var bottomContainer = Positioned(
      child: Container(
        decoration: const BoxDecoration(
          color: blackColor,
        ),
        child: Row(
          children: [
            recordButtonContainer,
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        padding: EdgeInsets.only(bottom: bottomSafeArea),
      ),
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      height: (bottomSafeArea + 92.0),
    );

    /// Recording Overlay Container
    var recordingOverlayContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(color: camController!.value.isRecordingVideo ? (showRecordingBorder ? darkRedColor : Colors.transparent) : Colors.transparent, width: 4.0),
          ),
          duration: const Duration(milliseconds: 800),
        ),
        ignoring: true,
      ),
      bottom: (bottomSafeArea + 92.0),
      top: (topSafeArea + 50.0),
      left: 0.0,
      right: 0.0,
    );

    /// Scaffold
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      key: cameraScreenScaffoldKey,
      body: SizedBox(
        child: Stack(
          children: [
            cameraContainer,
            recordingOverlayContainer,
            topContainer,
            bottomContainer,
          ],
          alignment: Alignment.center,
        ),
        width: pageWidth,
        height: pageHeight,
      ),
    );

  }

  /// Switch Camera
  void switchCamera() {
    selectedCameraIdx = selectedCameraIdx! < cameras!.length - 1 ? selectedCameraIdx! + 1 : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIdx ?? 0];
    initCameraController(selectedCamera);
  }

  /// Start Animation
  void startAnimation() async {
    recordingAnimationTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      setState(() => showRecordingBorder = !showRecordingBorder);
    });
  }

  /// Stop Animation
  void stopAnimation() async {
    recordingAnimationTimer!.cancel();
  }

  /// On Video Record Button Pressed
  void onVideoRecordButtonPressed() async {
    if (mounted) setState(() {});
    if (!camController!.value.isInitialized) {
//      print('Error: select a camera first.');
    }

    if (camController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
//      print("Recording Already Started");
    }

    try {
      await camController!.startVideoRecording();
      startAnimation();
      timeCounter.start();
    } on CameraException { // catch (e) {
//    print(e.description);
    }
  }

  /// On Stop Button Pressed
  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      stopAnimation();
      stopVideoRecording();
      timeCounter.stop();
//      print('Video recorded to: $videoPath');
    });
  }

  /// On Pause Button Pressed
  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
//      print('Video recording paused');
    });
  }

  /// On Resume Button Pressed
  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
//      print('Video recording resumed');
    });
  }

  /// Stop Video Recording
  Future<void> stopVideoRecording() async {
    if (!camController!.value.isRecordingVideo) {
      return;
    }

    try {
      XFile videoFile = await camController!.stopVideoRecording();
      setState(() {
        videoPath = videoFile.path;
      });
//      print("THE ACTUAL PATH OF THE VIDEO: ${videoFile.path}");
      //await camController!.stopVideoRecording();
//      print("STOPPED RECORDING");
    } on CameraException { // catch (e) {
//      print("ERROR ON STOP VIDEO RECORDING");
      return;
    }

    startVideoPlayer();
  }

  /// Pause Video Recording
  Future<void> pauseVideoRecording() async {
    if (!camController!.value.isRecordingVideo) {
      return;
    }
    try {
      await camController!.pauseVideoRecording();
    } on CameraException { // catch (e) {
      rethrow;
    }
  }

  /// Resume Video Recording
  Future<void> resumeVideoRecording() async {
    if (!camController!.value.isRecordingVideo) {
      return;
    }

    try {
      await camController!.resumeVideoRecording();
    } on CameraException { // catch (e) {
      rethrow;
    }
  }

  /// Start Video Player
  void startVideoPlayer() async {
//    final Directory extDir = widget.appDocsDir;
//    print("DIRECTORY: ${extDir.path}");
//    final String dirPath = '${extDir.path}/Recordings';
//    print("DIRECTORY PATH: $dirPath");
//    await Directory(dirPath).create(recursive: true);
//    final String filePath = '$dirPath/test.mp4';
//    print("FILEPATH: $filePath");

    final File file = File(videoPath!);

    WidgetsBinding.instance!.removeObserver(this);
    if (recordingAnimationTimer != null) {
      recordingAnimationTimer!.cancel();
    }
    if (camController != null) {
      camController!.dispose();
    }
    if (timeCounter.isRunning) {
      timeCounter.stop();
    }
    timeCounter.reset();
//    print("FILEPATH FROM FILE: ${file.path}");

    var route = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return VideoEditorScreen(
          appDocsDir: widget.appDocsDir,
          videoFile: file,
          videoFilePath: videoPath!,
//          videoController: videoController,
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutExpo,
              reverseCurve: Curves.fastOutSlowIn,
            ),
          ),
          child: FadeTransition(
            opacity: Tween(
              begin: 1.0,
              end: 0.4,
            ).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.fastOutSlowIn,
                reverseCurve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );

    final result = await Navigator.push(
      context,
      route,
    );
    if (result == "Cancel") {
//      await Future.delayed(const Duration(milliseconds: 600));
      bool exists = await file.exists();
      if (exists) {
        await file.delete();
      }
      availableCameras().then((availableCameras) {
        cameras = availableCameras;
        if (cameras!.isNotEmpty) {
          setState(() {
            selectedCameraIdx = 0;
          });
          initCameraController(cameras![selectedCameraIdx ?? 0]).then((void v) {});
        }
        else{
//        print("No camera available");
        }
      }).catchError((err) {
//      print('Error: $err.code\nError Message: $err.message');
      });
      setState(() {});
    }
    else if (result == "Done") {
      bool exists = await file.exists();
      if (exists) {
        await file.delete();
      }
      Navigator.pop(context, "Refresh");
    }

  }

//  Future<void> _startVideoPlayer() async {
//    final VideoPlayerController controller =
//    VideoPlayerController.file(File(videoPath));
//    videoPlayerListener = () {
//      if (videoController != null && videoController.value.size != null) {
//        // Refreshing the state to update video player with the correct ratio.
//        if (mounted) setState(() {});
//        videoController.removeListener(videoPlayerListener);
//      }
//    };
//    vcontroller.addListener(videoPlayerListener);
//    await vcontroller.setLooping(true);
//    await vcontroller.initialize();
//    await videoController?.dispose();
//    if (mounted) {
//      setState(() {
//        imagePath = null;
//        videoController = vcontroller;
//      });
//    }
//    await vcontroller.play();
//  }


}
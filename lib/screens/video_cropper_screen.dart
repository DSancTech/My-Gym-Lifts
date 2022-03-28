import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:video_editor/video_editor.dart';
import 'package:helpers/helpers.dart';

class VideoCropperScreen extends StatefulWidget {
  const VideoCropperScreen({Key? key, required this.videoEditorController}) : super(key: key);

  final VideoEditorController videoEditorController;

  @override
  VideoCropperScreenState createState() => VideoCropperScreenState();

}

class VideoCropperScreenState extends State<VideoCropperScreen> with RouteAware, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> videoCropperScreenScaffoldKey = GlobalKey<ScaffoldState>();

  /// Init State
  @override
  void initState() {
    super.initState();

//    widget.videoController.addListener(checkVideo);

  }

//  /// Check Video
//  void checkVideo() async {
//    if(videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
//      print('video Started');
//    }
//    if(videoPlayerController.value.position == videoPlayerController.value.duration) {
//      print('video Ended');
//    }
//  }

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
    super.dispose();
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

    /// Cancel Button Container
    var cancelButtonContainer = SizedBox(
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
          Navigator.pop(context);
        },
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Okay Button Container
    var okayButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          Icons.check_rounded,
          size: 24.0,
          color: lightBlueColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () {
          widget.videoEditorController.updateCrop();
          Navigator.pop(context);
        },
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Top Container
    var topContainer = Container(
      child: Row(
        children: [
          cancelButtonContainer,
          const Expanded(child: SizedBox(),),
          okayButtonContainer,
        ],
      ),
      margin: EdgeInsets.only(top: topSafeArea, bottom: 16.0),
    );

    /// Main Crop Container
    var mainCropContainer = Expanded(
      child: AnimatedInteractiveViewer(
        maxScale: 2.4,
        child: CropGridViewer(controller: widget.videoEditorController, horizontalMargin: 60),
      ),
    );

    /// Rotate Left Button Container
    var rotateLeftButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          Icons.rotate_left_rounded,
          size: 24.0,
          color: whiteColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () => widget.videoEditorController.rotate90Degrees(RotateDirection.left),
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Rotate Right Button Container
    var rotateRightButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          Icons.rotate_right_rounded,
          size: 24.0,
          color: whiteColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () => widget.videoEditorController.rotate90Degrees(RotateDirection.right),
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Bottom Container
    var bottomContainer = Container(
      child: Row(
        children: [
          rotateLeftButtonContainer,
          rotateRightButtonContainer,
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      margin: EdgeInsets.only(bottom: bottomSafeArea + 16.0, top: 16.0),
    );

    /// Scaffold
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      key: videoCropperScreenScaffoldKey,
      body: SizedBox(
        child: Column(
          children: [
            topContainer,
            mainCropContainer,
            bottomContainer,
          ],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        height: pageHeight,
        width: pageWidth,
      ),
    );
  }

}
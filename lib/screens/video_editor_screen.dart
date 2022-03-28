import 'package:flutter/material.dart';
import 'dart:io';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';
import 'package:helpers/helpers.dart';
import 'package:my_gym_lifts/screens/video_cropper_screen.dart';
import 'package:my_gym_lifts/screens/video_data_screen.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({Key? key, required this.appDocsDir, required this.videoFile, required this.videoFilePath}) : super(key: key);

  final Directory appDocsDir;

  final String videoFilePath;
  final File videoFile;

  @override
  VideoEditorScreenState createState() => VideoEditorScreenState();

}

class VideoEditorScreenState extends State<VideoEditorScreen> with RouteAware, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> videoEditorScreenScaffoldKey = GlobalKey<ScaffoldState>();

  final exportingProgress = ValueNotifier<double>(0.0);
  final isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool exported = false;
  String exportText = "";
  late VideoEditorController videoEditorController;

  bool showLoading = false;

  /// Init State
  @override
  void initState() {
    videoEditorController = VideoEditorController.file(widget.videoFile, maxDuration: const Duration(minutes: 10))..initialize().then((_) => setState(() {}));

    super.initState();
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
    exportingProgress.dispose();
    isExporting.dispose();
    videoEditorController.dispose();
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

    /// Screen orientation variables.
//    var orientation = MediaQuery.of(context).orientation;
//    var onPortrait = (orientation == Orientation.portrait);

    /// Cancel Alert
    Alert cancelAlert = Alert(
      context: context,
      type: AlertType.none,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        backgroundColor: blackColor,
        overlayColor: darkGrayColor.withOpacity(0.9),
        titleStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: mediumFontSize,
          fontWeight: semiBoldWeight,
          decoration: TextDecoration.none,
          color: whiteColor,
        ),
        descStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: smallFontSize,
          fontWeight: lightWeight,
          decoration: TextDecoration.none,
          color: whiteColor,
        ),
        descTextAlign: TextAlign.center,
        animationDuration: const Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: blackColor,
            width: 0.0,
          ),
        ),
        alertAlignment: Alignment.center,
      ),
      title: "Are You Sure?",
      desc: "This video will be deleted if you continue.",
      buttons: [
        DialogButton(
          child: const Text(
            "Yes",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: smallFontSize,
              fontWeight: boldWeight,
              decoration: TextDecoration.none,
              color: whiteColor,
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          color: lightGrayColor,
        ),
        DialogButton(
          child: const Text(
            "No",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: smallFontSize,
              fontWeight: semiBoldWeight,
              decoration: TextDecoration.none,
              color: whiteColor,
            ),
          ),
          onPressed: () => Navigator.pop(context, false),
          color: darkGrayColor,
        )
      ],
    );

    /// Cancel Button Container
    var cancelButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: regularFontSize,
            fontWeight: semiBoldWeight,
            decoration: TextDecoration.none,
            color: whiteColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () async {
          final result = await cancelAlert.show();
          if (result == true) {
            Navigator.pop(context, "Cancel");
          }
        },
      ),
      width: 70.0,
      height: 50.0,
    );

    /// Crop Button Container
    var cropButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          Icons.crop_rounded,
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
        onPressed: () => openCropScreen(),
      ),
      width: 70.0,
      height: 50.0,
    );

    /// Top Bar Container
    var topBarContainer = Container(
      decoration: const BoxDecoration(
        color: blackColor,
      ),
      child: Row(
        children: [
          cancelButtonContainer,
          const Expanded(
            child: SizedBox(),
          ),
          cropButtonContainer,
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      padding: EdgeInsets.only(top: topSafeArea),
      margin: const EdgeInsets.only(bottom: 12.0),
      height: (topSafeArea + 50.0),
    );

    /// Main Container
    var mainContainer = Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: blackColor,
        ),
        child: Stack(alignment: Alignment.center, children: [
          CropGridViewer(
            controller: videoEditorController,
            showGrid: false,
          ),
          AnimatedBuilder(
            animation: videoEditorController.video,
            builder: (_, __) => AnimatedOpacity(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: whiteColor, width: 4.0),
                ),
                child: ElevatedButton(
                  child: Container(
                    child: Icon(
                      videoEditorController.isPlaying ? pauseIconData : playIconData,
                      size: 20.0,
                      color: whiteColor,
                    ),
                    margin: EdgeInsets.only(left: videoEditorController.isPlaying ? 0.0 : 3.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: blackColor,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    elevation: 0.0,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    if (videoEditorController.isPlaying) {
                      videoEditorController.video.pause();
                    }
                    else {
                      videoEditorController.video.play();
                    }
                  },
                ),
                width: 50.0,
                height: 50.0,
              ),
              opacity: videoEditorController.isPlaying ? 0.4 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutExpo,
            ),
          ),
        ]),
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 24.0),
      ),
    );

    /// Trim Container
    var trimContainer = SizedBox(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: videoEditorController.video,
            builder: (_, __) {
              final duration = videoEditorController.video.value.duration.inSeconds;
              final pos = videoEditorController.trimPosition * duration;
              final start = videoEditorController.minTrim * duration;
              final end = videoEditorController.maxTrim * duration;
              return Padding(
                padding: const Margin.horizontal(16.0),
                child: Row(children: [
                  Text(
                    formatter(Duration(seconds: pos.toInt())),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: smallFontSize,
                      fontWeight: regularWeight,
                      decoration: TextDecoration.none,
                      color: whiteColor,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    formatter(Duration(seconds: end.toInt())),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: smallFontSize,
                      fontWeight: regularWeight,
                      decoration: TextDecoration.none,
                      color: whiteColor,
                    ),
                  ),
                ]),
              );
            },
          ),
          Container(
            width: pageWidth,
            margin: const EdgeInsets.only(top: 12.0),
            child: TrimSlider(
              controller: videoEditorController,
              height: height,
              horizontalMargin: 16.0,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );

    /// Continue Button Container
    var continueButtonContainer = Container(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [lightBlueColor, darkBlueColor],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          child: const Text(
            'Continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: regularFontSize,
              fontWeight: semiBoldWeight,
              decoration: TextDecoration.none,
              color: whiteColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: blackColor,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            elevation: 0.0,
            padding: EdgeInsets.zero,
          ),
          onPressed: () => exportVideo(context, pageWidth, pageHeight),
        ),
      ),
      width: pageWidth,
      height: 50.0,
      margin: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, bottomSafeArea + 16.0),
    );

    /// Loading Container
    var loadingContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: Container(
            decoration: BoxDecoration(
              color: blackColor.withOpacity(0.8),
            ),
            child: const SpinKitFadingCircle(
              size: 60.0,
              color: lightBlueColor,
            ),
            alignment: Alignment.center,
          ),
          opacity: showLoading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutExpo,
        ),
        ignoring: showLoading ? false : true,
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );

    /// Scaffold
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      key: videoEditorScreenScaffoldKey,
      body: videoEditorController.initialized ? Stack(
        children: [
          Column(
            children: [
            topBarContainer,
            mainContainer,
            trimContainer,
            continueButtonContainer,
          ]),
          loadingContainer,
      ]) : const Center(child: CircularProgressIndicator()),
    );
  }

  /// Time Formatter
  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");
  

  /// Open Crop Screen
  void openCropScreen() async {
    var route = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return VideoCropperScreen(videoEditorController: videoEditorController);
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
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
  }

  /// Export Video
  void exportVideo(BuildContext context, double pageWidth, double pageHeight) async {
    Alert errorAlert = Alert(
      context: context,
      type: AlertType.none,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        backgroundColor: blackColor,
        overlayColor: darkGrayColor.withOpacity(0.9),
        titleStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: mediumFontSize,
          fontWeight: semiBoldWeight,
          decoration: TextDecoration.none,
          color: whiteColor,
        ),
        descStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: smallFontSize,
          fontWeight: lightWeight,
          decoration: TextDecoration.none,
          color: whiteColor,
        ),
        descTextAlign: TextAlign.center,
        animationDuration: const Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: blackColor,
            width: 0.0,
          ),
        ),
        alertAlignment: Alignment.center,
      ),
      title: "Whoops!",
      desc: "Something appears to have gone wrong.",
      buttons: [
        DialogButton(
          child: const Text(
            "Okay",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: smallFontSize,
              fontWeight: boldWeight,
              decoration: TextDecoration.none,
              color: whiteColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: lightGrayColor,
        ),
      ],
    );

    setState(() {
      showLoading = true;
    });
    isExporting.value = true;
    bool firstStat = true;
    await videoEditorController.exportVideo(
      onProgress: (statics) {
        if (firstStat) {
          firstStat = false;
        } else {
          exportingProgress.value = statics.getTime() / videoEditorController.video.value.duration.inMilliseconds;
        }
      },
      onCompleted: (file) async {
        isExporting.value = false;
        if (!mounted) return;
        if (file != null) {
          bool? saveSuccess;
          await GallerySaver.saveVideo(file.path).then((success) => {
            saveSuccess = success
          }).catchError((error) {
            saveSuccess = false;
          });

          if (saveSuccess == true) {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.photos,
            ].request();
            if (statuses[Permission.photos] == PermissionStatus.granted) {
              List<AssetPathEntity> list = await PhotoManager.getAssetPathList(type: RequestType.video);
              List<AssetEntity> videoList = await list[0].assetList;
              AssetEntity entity = videoList[0];
              Uint8List? thumbDataWithSize = await entity.thumbDataWithSize((pageWidth * 3).round(),(pageWidth * 3).round());
              String id = const Uuid().v1();

              var route = PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return VideoDataScreen(
                      appDocsDir: widget.appDocsDir,
                      videoData: {
                        "id": id,
                        "name": "",
                        "pr": false,
                        "lbs": 0.0,
                        "kg": 0.0,
                        "reps": 0,
                        "rpe": 0,
                        "rir": 10,
                        "percentage": 0.0,
                        "description": "",
                        "keywords": "",
                        "thumb": thumbDataWithSize,
                        "asset_entity": entity.id,
                        "duration": durationToString(entity.videoDuration),
                        "date": DateTime.now(),
                      },
                      index: 0,
                      newVideo: true,
                      dismissDown: false,
                      reloadData: () {

                      }
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

              setState(() {
                showLoading = false;
              });

              if (result == "Done") {
                Navigator.pop(context, "Done");
              }
            }
          }
          else {
            errorAlert.show();
          }
        }
        else {
          setState(() {
            showLoading = false;
          });
          errorAlert.show();
        }
        setState(() => exported = true);
        Misc.delayed(2000, () => setState(() => exported = false));
      },
    );
  }

  /// Duration To String
  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

}
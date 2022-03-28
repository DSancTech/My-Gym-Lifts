import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key, required this.name, required this.appDocsDir, required this.entity, required this.thumb}) : super(key: key);

  final Directory appDocsDir;
  final Uint8List thumb;
  final AssetEntity entity;
  final String name;

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();

}

class VideoPlayerScreenState extends State<VideoPlayerScreen> with RouteAware, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> videoPlayerScreenScaffoldKey = GlobalKey<ScaffoldState>();

  /// Video Controller
  late VideoPlayerController videoController;
  bool isLoading = true;

  /// Init State
  @override
  void initState() {
    initVideo();

    super.initState();
  }

  /// Init Video
  initVideo() async {
    final videoFile = await widget.entity.file;
    if (videoFile?.exists() != null) {
      videoController = VideoPlayerController.file(videoFile!);
      videoController.addListener(() {
        setState(() {});
      });
      await videoController.initialize().then((_) => setState(() {}));
      videoController.setVolume(100.0);
      videoController.setLooping(true);
      videoController.play();
      setState(() {
        isLoading = false;
      });
    }
    else {
      // TODO: Some older videos randomly will not load the file. Then screen pops and can't be played. Not replicable just based off of date of creation.
      Navigator.pop(context, "Error");
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
    videoController.pause();
    videoController.dispose();
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
          videoController.pause();
          videoController.dispose();
          Navigator.pop(context);
        },
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Export Button Container
    var exportButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          exportIconData,
          size: 14.0,
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
        onPressed: () => exportVideo(context),
      ),
      height: 50.0,
      width: 50.0,
    );

    /// Top Container
    var topContainer = Container(
      child: Row(
        children: [
          cancelButtonContainer,
          const Expanded(child: SizedBox()),
          exportButtonContainer,
        ],
      ),
      margin: EdgeInsets.only(top: topSafeArea, bottom: 16.0),
    );

    /// Loading Overlay Container
    var loadingOverlayContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(widget.thumb),
                fit: BoxFit.contain,
              ),
            ),
            child: const SpinKitFadingCircle(
              size: 80.0,
              color: whiteColor,
            ),
            alignment: Alignment.center,
          ),
          opacity: isLoading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
        ),
        ignoring: isLoading ? false : true,
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );

    /// Video Container
    var videoContainer = Positioned(
      child: (isLoading == false) ? AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: VideoPlayer(videoController),
      ) : Container(),
    );

    /// Play Pause Button Container
    var playPauseButtonContainer = (isLoading == false) ? Positioned(
      child: AnimatedBuilder(
        animation: videoController,
        builder: (_, __) => AnimatedOpacity(
          child: SizedBox(
            child: ElevatedButton(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: whiteColor, width: 4.0),
                ),
                child: Icon(
                  videoController.value.isPlaying ? pauseIconData : playIconData,
                  size: 20.0,
                  color: whiteColor,
                ),
                width: 50.0,
                height: 50.0,
                padding: EdgeInsets.only(left: videoController.value.isPlaying ? 0.0 : 3.0),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: blackColor,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                elevation: 0.0,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                if (videoController.value.isPlaying) {
                  videoController.pause();
                }
                else {
                  videoController.play();
                }
              },
            ),
            width: 50.0,
            height: 50.0,
          ),
          opacity: videoController.value.isPlaying ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutExpo,
        ),
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    ) : const SizedBox();

    /// Mute Button Container
    var muteButtonContainer = (isLoading == false) ? Positioned(
      child: AnimatedBuilder(
        animation: videoController,
        builder: (_, __) => Opacity(
          child: ElevatedButton(
            child: Container(
              child: Icon(
                (videoController.value.volume != 0.0) ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                size: 20.0,
                color: whiteColor,
              ),
              padding: const EdgeInsets.only(left: 4.0, top: 2.0),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onPrimary: blackColor,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 0.0,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              if (videoController.value.volume != 0.0) {
                videoController.setVolume(0.0);
              }
              else {
                videoController.setVolume(100.0);
              }
            },
          ),
          opacity: (videoController.value.volume != 0.0) ? 1.0 : 0.6,
        ),
      ),
      bottom: 0.0,
      right: 0.0,
      width: 50.0,
      height: 50.0,
    ) : const SizedBox();

    /// Main Video Container
    var mainVideoContainer = Expanded(
      child: SizedBox(
        child: Stack(
          children: [
            videoContainer,
            playPauseButtonContainer,
            muteButtonContainer,
            loadingOverlayContainer,
          ],
          alignment: Alignment.center,
        ),
      ),
    );

    /// Loading Slider
    var loadingSlider = SliderTheme(
      data: const SliderThemeData(
        thumbColor: whiteColor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
        trackHeight: 4,
      ),
      child: Slider(min: 0.0, max: 100.0, value: 0.0, onChanged: (value) {}, activeColor: lightBlueColor, inactiveColor: whiteColor.withOpacity(0.15)),
    );

    /// Video Slider
    var videoSlider = SliderTheme(
      data: const SliderThemeData(
          thumbColor: whiteColor,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
          trackHeight: 4,
      ),
      child: Slider(
        min: 0.0,
        max: isLoading ? 100.0 : videoController.value.duration.inMilliseconds.toDouble(),
        value: isLoading ? 0.0 : videoController.value.position.inMilliseconds.toDouble(),
        onChanged: (value) {
          videoController.seekTo(Duration(milliseconds: value.toInt()));
        },
        activeColor: lightBlueColor,
        inactiveColor: whiteColor.withOpacity(0.15),
      ),
    );

    /// Bottom Container
    var bottomContainer = Container(
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: isLoading ? loadingSlider : AnimatedBuilder(
            animation: videoController,
            builder: (_, __) => videoSlider,
          ),
        ),
        ignoring: isLoading ? true : false,
      ),
      margin: EdgeInsets.only(bottom: bottomSafeArea + 16.0, top: 16.0),
      height: 50.0,
    );

    /// Dismissible Page
    return DismissiblePage(
      onDismiss: () {
        videoController.pause();
        videoController.dispose();
        Navigator.of(context).pop();
      },
      isFullScreen: true,
      dragSensitivity: .4,
      maxTransformValue: 4,
      direction: DismissDirection.vertical,
      child: SizedBox(
        child: Column(
          children: [
            topContainer,
            mainVideoContainer,
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

  /// Export Video
  void exportVideo(BuildContext context) async {
    if (isLoading == false) {
      var file = await widget.entity.file;
      if (file != null) {
        List<String> filePath = [file.path];
        await Share.shareFiles(filePath,
          text: widget.name,
        );
      }
    }
  }

}
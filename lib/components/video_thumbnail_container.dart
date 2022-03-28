import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:my_gym_lifts/components/shared.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class VideoThumbnailContainer extends StatefulWidget {
  const VideoThumbnailContainer({Key? key, required this.newVideo, required this.videoData, required this.mainButtonAction, required this.backButtonAction, required this.isOpened, required this.isEditing, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final bool isOpened;
  final bool isEditing;
  final bool newVideo;

  final VoidCallback mainButtonAction;
  final VoidCallback backButtonAction;

  final Map<String,dynamic> videoData;

  @override
  VideoThumbnailContainerState createState() => VideoThumbnailContainerState();

}

class VideoThumbnailContainerState extends State<VideoThumbnailContainer> with RouteAware {

  /// Init State
  @override
  void initState() {
    super.initState();

//    AssetEntity entity = widget.mainData[outerIndex]["asset_list"][innerIndex];
//    Uint8List? thumbData = await entity.thumbDataWithSize((widget.pageWidth ~/ 1),(widget.pageWidth ~/ 1));

//    print("THUMBNAIL VIDEO DATA:");
//    print(widget.videoData);

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
    super.dispose();
  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Name Text Container
    var nameTextContainer = SizedBox(
      child: AutoSizeText(
        widget.newVideo ? "" : widget.videoData["name"],
        style: const TextStyle(
          fontFamily: fontFamily,
          fontSize: mediumFontSize,
          fontWeight: boldWeight,
          color: whiteColor,
          decoration: TextDecoration.none,
        ),
        minFontSize: regularFontSize,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );

    /// Description Text Container
    var descriptionTextContainer = Expanded(
      child: Container(
        child: AutoSizeText(
          widget.newVideo ? "" : "${widget.videoData["lbs"]} lbs / ${widget.videoData["kg"]} kg\n${widget.videoData["reps"]} Rep${(widget.videoData["reps"] > 1) ? "s" : ""}\nRPE ${widget.videoData["rpe"]} / ${widget.videoData["rir"]} RIR",
          style: const TextStyle(
            fontFamily: fontFamily,
            fontSize: smallFontSize,
            fontWeight: regularWeight,
            color: whiteColor,
            decoration: TextDecoration.none,
          ),
          minFontSize: smallFontSize,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ),
        margin: const EdgeInsets.only(top: 2.0),
      ),
    );

    /// Date Text Container
    var dateTextContainer = SizedBox(
      child: AutoSizeText(
        widget.isOpened ? "" : widget.videoData["date"],
        style: const TextStyle(
          fontFamily: fontFamily,
          fontSize: smallFontSize,
          fontWeight: semiBoldWeight,
          color: whiteColor,
          decoration: TextDecoration.none,
        ),
        minFontSize: smallFontSize,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
    );

    /// Duration Text Container
    var durationTextContainer = Positioned(
      child: IgnorePointer(
        child: Text(
          widget.videoData["duration"],
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: fontFamily,
            fontSize: smallFontSize,
            fontWeight: regularWeight,
            color: whiteColor,
            decoration: TextDecoration.none,
          ),
        ),
        ignoring: true,
      ),
      bottom: 12.0,
      right: 12.0,
    );

    /// Data Container
    var dataContainer = AnimatedPositioned(
      child: SizedBox(
        child: Column(
          children: [
            nameTextContainer,
            descriptionTextContainer,
            dateTextContainer,
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
      left: widget.isOpened ? -widget.pageWidth : 12.0,
      top: 12.0,
      bottom: 12.0,
      width: (widget.pageWidth - 32.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// PR Container
    var prContainer = AnimatedPositioned(
      child: Opacity(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: yellowColor,
          ),
          child: const Text(
            'PR',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: extraSmallFontSize,
              fontWeight: extraBoldWeight,
              color: blackColor,
              decoration: TextDecoration.none,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
        ),
        opacity: widget.videoData["pr"] ? 1.0 : 0.0,
      ),
      top: 12.0,
      right: widget.isOpened ? -widget.pageWidth : 12.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Back Button Container
    var backButtonContainer = AnimatedPositioned(
      child: ElevatedButton(
        child: const Icon(
          Icons.close,
          size: 22.0,
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
          widget.backButtonAction();
        },
      ),
      width: 50.0,
      height: 50.0,
      left: widget.isOpened ? 4.0 : -50.0,
      top: widget.topSafeArea,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Main Button Container
    var mainButtonContainer = Positioned(
      child: ElevatedButton(
        child: AnimatedOpacity(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: whiteColor, width: 4.0),
              ),
              child: const Icon(
                playIconData,
                color: whiteColor,
                size: 20.0,
              ),
              alignment: Alignment.center,
              width: 50.0,
              height: 50.0,
              padding: const EdgeInsets.only(left: 3.0),
              margin: EdgeInsets.only(top: widget.topSafeArea),
            ),
          ),
          opacity: widget.isOpened ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: blackColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(widget.isOpened ? 0.0 : 20.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () => widget.mainButtonAction(),
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );

    /// Overlay Container
    var overlayContainer = Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: blackColor.withOpacity(widget.isOpened ? 0.3 : 0.5),
          borderRadius: BorderRadius.all(Radius.circular(widget.isOpened ? 0.0 : 16.0)),
        ),
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );
    
    /// Main Container
    return Hero(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(widget.videoData["thumb"]),
            fit: BoxFit.cover,
          ),
          color: lightGrayColor,
          borderRadius: BorderRadius.all(Radius.circular(widget.isOpened ? 0.0 : 16.0)),
        ),
        child: ClipRect(
          child: Stack(
            children: [
              overlayContainer,
              durationTextContainer,
              dataContainer,
              prContainer,
              mainButtonContainer,
              backButtonContainer,
            ],
            alignment: Alignment.center,
          ),
        ),
//        height: widget.pageHeight,
        width: widget.pageWidth,
        padding: EdgeInsets.zero,
      ),
      tag: widget.videoData["id"],
    );

  }

}
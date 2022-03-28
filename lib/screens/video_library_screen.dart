import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:shimmer/shimmer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:my_gym_lifts/screens/video_data_screen.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoLibraryScreen extends StatefulWidget {
  const VideoLibraryScreen({Key? key, required this.videosData,  required this.appDocsDir, required this.mainData, required this.pageWidth}) : super(key: key);

  final Directory appDocsDir;
  final List<Map<String, dynamic>> mainData;
  final double pageWidth;
  final List<dynamic> videosData;

  @override
  VideoLibraryScreenState createState() => VideoLibraryScreenState();

}

class VideoLibraryScreenState extends State<VideoLibraryScreen> with RouteAware, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> videoLibraryScreenScaffoldKey = GlobalKey<ScaffoldState>();

  /// Main Page Controller
  PageController mainPageController = PageController();
  List<Map<String, dynamic>> thumbData = [];
  bool thumbDataIsLoading = true;
//  List<String> selectedIDs = [];
  int currentPage = 0;

//  ScrollController mainScrollController = ScrollController(initialScrollOffset: 0.0);

  /// Menu
  bool albumMenuOpen = false;
//  ScrollController menuScrollController = ScrollController(initialScrollOffset: 0.0);

  /// Init State
  @override
  void initState() {
    super.initState();

    loadData();
  }

  /// Load Data
  loadData() async {
    List<Map<String, dynamic>> intThumbData = [];
    for(var outerIndex = 0; outerIndex < widget.mainData.length; outerIndex++) {
      var thumbList = [];
      for(var innerIndex = 0; innerIndex < widget.mainData[outerIndex]["asset_list"].length; innerIndex++) {
        AssetEntity entity = widget.mainData[outerIndex]["asset_list"][innerIndex];
        Uint8List? thumbDataWithSize = await entity.thumbDataWithSize((widget.pageWidth ~/ 2),(widget.pageWidth ~/ 2));
        //Uint8List? thumbDataWithSize = await entity.thumbDataWithSize((widget.pageWidth ~/ 1),(widget.pageWidth ~/ 1));
        thumbList.add({
          "entity": entity,
          "thumb": thumbDataWithSize,
          "duration": durationToString(entity.videoDuration),
        });
      }
      intThumbData.add({
        "index": outerIndex,
        "data": thumbList,
      });
    }
    setState(() {
      thumbData = intThumbData;
      thumbDataIsLoading = false;
    });
//    List<Map<String, dynamic>> data = [];
//    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(type: RequestType.video);
//    for(var i = 0; i < list.length; i++) {
//      List<AssetEntity> videoList = await list[i].assetList;
//      data.add({
//        "name": list[i].name,
//        "id": list[i].id,
//        "asset_count": list[i].assetCount,
//        "asset_list": videoList,
//      });
//    }

//    AssetPathEntity data = list[0]; // 1st album in the list, typically the "Recent" or "All" album
//    List<AssetEntity> videosList = await data.assetList;
//    AssetEntity entity = videosList[0];
//    File file = await entity.file;
//    Uint8List thumbBytes = await entity.thumbData; // thumb data ,you can use Image.memory(thumbBytes); size is 64px*64px;
//    Uint8List thumbDataWithSize = await entity.thumbDataWithSize(200,200);
//    AssetType type = videosList[0].type; // the type of asset enum of other,image,video
//    Duration duration = videosList[0].videoDuration; //if type is not video, then return null.
//    Size size = videosList[0].size;
//    int width = videosList[0].width;
//    int height = videosList[0].height;
//    DateTime createDt = videosList[0].createDateTime;
//    DateTime modifiedDt = videosList[0].modifiedDateTime;
//    String url = await videosList[0].getMediaUrl();
//
//    print("File: $file\nThumb Bytes: $thumbBytes\nThumb Data With Size: $thumbDataWithSize\nType: $type\nDuration: $duration\nSize: $size\nWidth: $width\nHeight: $height\nCreated DateTime: $createDt\nModified DateTime: $modifiedDt\nURL: $url");
//    File: File: '/private/var/mobile/Containers/Data/Application/9FAD7B71-3A16-4640-AA60-969554F519B1/tmp/.video/IMG_8756.MP4'
//    Thumbnail: child: Image.memory(Uint8List bytes); or var _image = MemoryImage(image);
//    Type: AssetType.video
//    Duration: 0:00:17.000000
//    Size: Size(886.0, 1920.0)
//    Width: 886
//    Height: 1920
//    Created DateTime: 2020-12-01 10:54:59.000
//    Modified DateTime: 2020-12-01 10:55:00.000
//    URL: file:///var/mobile/Media/DCIM/118APPLE/IMG_8756.MP4

  }

  /// Duration To String
  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
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
    thumbData.clear();
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
    
    /// Close Button
    var closeButtonContainer = SizedBox(
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
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      width: 50.0,
      height: 50.0,
    );

    /// Top Bar Container
    var topBarContainer = Positioned(
      child: Container(
        decoration: const BoxDecoration(
          color: blackColor,
        ),
        child: Row(
          children: [
            closeButtonContainer,
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  AutoSizeText(
                    widget.mainData[currentPage]["name"],
                    style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: mediumFontSize,
                      fontWeight: boldWeight,
                      color: whiteColor,
                      decoration: TextDecoration.none,
                    ),
                    minFontSize: smallFontSize,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      child: Row(
                        children: const [
                          Icon(
                            menuTwoIconData,
                            color: whiteColor,
                            size: 8.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          AutoSizeText(
                            "Switch Albums",
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: extraSmallFontSize,
                              fontWeight: regularWeight,
                              color: whiteColor,
                              decoration: TextDecoration.none,
                            ),
                            minFontSize: extraSmallFontSize,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: lightBlueColor,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        elevation: 0.0,
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      ),
                      onPressed: () {
                        setState(() {
                          albumMenuOpen = !albumMenuOpen;
                        });
                      },
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            const SizedBox(
              width: 50.0,
              height: 0.0,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        padding: EdgeInsets.only(top: topSafeArea),
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      height: (topSafeArea + 90.0),
    );

    /// Main Container
    var mainContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: SizedBox(
            child: GridView.count(
              padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, bottomSafeArea + 1.0),
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              physics: const AlwaysScrollableScrollPhysics(),
              children: List.generate(widget.mainData[currentPage]["asset_list"].length, (innerIndex) {
                return thumbDataIsLoading ? Shimmer.fromColors(
                  child: Container(
                    color: lightGrayColor,
                    margin: const EdgeInsets.all(0.5),
                  ),
                  baseColor: lightGrayColor,
                  highlightColor: const Color(0xFF181C1E),
                  direction: ShimmerDirection.ltr,
                  enabled: true,
                  period: const Duration(seconds: 2),
                ) : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(thumbData[currentPage]["data"][innerIndex]["thumb"]),
                      fit: BoxFit.cover,
                    ),
                    color: lightGrayColor,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            color: blackColor.withOpacity(0.1),
                            border: Border.all(color: Colors.transparent, width: 0.0),
                          ),
                          child: ElevatedButton(
                            child: Container(),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              onPrimary: lightBlueColor,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                              elevation: 0.0,
                              padding: const EdgeInsets.all(0.0),
                            ),
                            onPressed: () async {
                              Uint8List? thumbDataWithSize = await thumbData[currentPage]["data"][innerIndex]["entity"].thumbDataWithSize((pageWidth * 3).round(),(pageWidth * 3).round());
                              openVideo(context, thumbData[currentPage]["data"][innerIndex]["entity"], thumbDataWithSize, thumbData[currentPage]["data"][innerIndex]["duration"]);
                            },
                          ),
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                        ),
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                      ),
                      AnimatedPositioned(
                        child: IgnorePointer(
                          child: Text(
                            thumbData[currentPage]["data"][innerIndex]["duration"],
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: fontFamily,
                              fontSize: extraSmallFontSize,
                              fontWeight: semiBoldWeight,
                              color: whiteColor,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          ignoring: true,
                        ),
                        bottom: 4.0,
                        right: 6.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(0.5),
                  alignment: Alignment.center,
                );
              }),
            ),
            width: pageWidth,
            height: (pageHeight - (topSafeArea + 50.0)),
          ),
          opacity: albumMenuOpen ? 0.2 : 1.0,
          duration: const Duration(milliseconds: 200),
        ),
        ignoring: albumMenuOpen,
      ),
      left: 0.0,
      right: 0.0,
      top: (topSafeArea + 90.0),
      bottom: 0.0,
    );

    /// Album Menu Container
    var albumMenuContainer = AnimatedPositioned(
      child: Container(
        decoration: const BoxDecoration(
          color: lightGrayColor,
        ),
        child: ListView.builder(
          itemCount: widget.mainData.length,
          padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              child: ElevatedButton(
                child: AutoSizeText(
                  widget.mainData[index]["name"],
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: regularFontSize,
                    fontWeight: (index == currentPage) ? boldWeight : regularWeight,
                    color: (index == currentPage) ? lightBlueColor : whiteColor,
                    decoration: TextDecoration.none,
                  ),
                  minFontSize: smallFontSize,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: lightBlueColor,
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 0.0,
                  padding: const EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    currentPage = index;
                    albumMenuOpen = false;
                  });
                },
              ),
            );
          },
        ),
      ),
      left: 0.0,
      right: 0.0,
      top: albumMenuOpen ? (topSafeArea + 90.0) : -200.0,
      height: 200.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );

    /// Loader Container
    var loaderContainer = Positioned(
      child: IgnorePointer(
        child: thumbDataIsLoading ? Container(
          color: blackColor.withOpacity(0.4),
          child: const SpinKitFadingCircle(
            size: 60.0,
            color: lightBlueColor,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: bottomSafeArea),
        ) : const SizedBox(),
        ignoring: thumbDataIsLoading ? false : true,
      ),
      left: 0.0,
      right: 0.0,
      top: (topSafeArea + 90.0),
      bottom: 0.0,
    );

    /// Dismissible Page
    return DismissiblePage(
      onDismiss: () => Navigator.of(context).pop(),
      isFullScreen: true,
      dragSensitivity: .4,
      maxTransformValue: 4,
      direction: DismissDirection.vertical,
      child: SizedBox(
        child: Stack(
          children: [
            mainContainer,
            loaderContainer,
            albumMenuContainer,
            topBarContainer,
          ],
          alignment: Alignment.center,
        ),
        width: pageWidth,
        height: pageHeight,
      ),
    );

  }

  /// Open Video
  void openVideo(BuildContext context, AssetEntity entity, Uint8List? thumb, String duration) async {
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
              "thumb": thumb,
              "asset_entity": entity.id,
              "duration": duration,
              "date": entity.createDateTime,
            },
            index: 0,
            newVideo: true,
            dismissDown: true,
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

    if (result == "Done") {
      Navigator.pop(context, "Refresh");
    }
  }

}
import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:after_layout/after_layout.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_gym_lifts/components/video_thumbnail_container.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainScreenListContainer extends StatefulWidget {
  const MainScreenListContainer({Key? key, required this.keyboardOpen, required this.keyboardHeight, required this.isLoading, required this.openVideo, required this.videoData, required this.reloadData, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;
  final bool keyboardOpen;
  final double keyboardHeight;

  final Map<String, dynamic> videoData;
  final VoidCallback reloadData;
  final bool isLoading;

  final Function(int index) openVideo;

  @override
  MainScreenListContainerState createState() => MainScreenListContainerState();

}

class MainScreenListContainerState extends State<MainScreenListContainer> with RouteAware, AfterLayoutMixin<MainScreenListContainer>, TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MainScreenListContainer> {

  /// Keep Page Alive
  @override
  bool get wantKeepAlive => true;

  /// Main Refresh Controller
  RefreshController mainRefreshController = RefreshController(initialRefresh: false);

  /// Init State
  @override
  void initState() {
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
    super.dispose();
  }

  /// After First Layout
  @override
  void afterFirstLayout(BuildContext context) {

  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Empty Container
    var emptyContainer = SizedBox(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  child: Icon(
                    videoLargeIconData,
                    size: 150.0,
                    color: whiteColor.withOpacity(0.15),
                  ),
                  width: 150.0,
                  height: 150.0,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                SizedBox(
                  child: AutoSizeText(
                    "No Videos Found",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: extraLargeFontSize,
                      fontWeight: extraBoldWeight,
                      color: whiteColor.withOpacity(0.20),
                      decoration: TextDecoration.none,
                    ),
                    minFontSize: smallFontSize,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  width: 160.0,
                ),
                SizedBox(
                  child: AutoSizeText(
                    "Record or import videos below.",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: smallFontSize,
                      fontWeight: regularWeight,
                      color: whiteColor.withOpacity(0.30),
                      decoration: TextDecoration.none,
                    ),
                    minFontSize: extraSmallFontSize,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  width: 160.0,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          opacity: widget.videoData["data"].isEmpty ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutExpo,
        ),
        ignoring: widget.videoData["data"].isEmpty ? false : true,
      ),
    );

    /// List Container
    var listContainer = SizedBox(
      child: AnimatedOpacity(
        child: SizedBox(
          child: SmartRefresher(
            controller: mainRefreshController,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              complete: const SizedBox(),
              waterDropColor: darkBlueColor,
              idleIcon: Container(
                child: const Icon(
                  reloadIconData,
                  size: 12.0,
                  color: whiteColor,
                ),
                margin: const EdgeInsets.only(top: 2.0),
              ),
            ),
            onRefresh: () {
              widget.reloadData();
              mainRefreshController.refreshCompleted();
            },
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + widget.keyboardHeight),
                itemCount: widget.videoData["data"].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: VideoThumbnailContainer(
                      pageHeight: widget.pageHeight,
                      pageWidth: widget.pageWidth,
                      bottomSafeArea: widget.bottomSafeArea,
                      topSafeArea: widget.topSafeArea,
                      isOpened: false,
                      isEditing: false,
                      newVideo: false,
                      videoData: widget.videoData["data"][index],
                      mainButtonAction: () => widget.openVideo(index),
                      backButtonAction: () {
                        return;
                      },
                    ),
                    width: widget.pageWidth,
                    height: 180.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                  );
                }
            ),
          ),
        ),
        opacity: widget.videoData["data"].isEmpty ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
      ),
    );

    /// Loading Container
    var loadingContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: Container(
            decoration: BoxDecoration(
              color: blackColor.withOpacity(0.6),
            ),
            child: const Center(
              child: SpinKitFadingCircle(
                size: 60.0,
                color: lightBlueColor,
              ),
            ),
          ),
          opacity: widget.isLoading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
        ),
        ignoring: widget.isLoading ? false : true,
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );

    /// Main Container
    return Container(
      child: Stack(
        children: [
          listContainer,
          emptyContainer,
          loadingContainer,
        ],
        alignment: Alignment.center,
      ),
      alignment: Alignment.center,
      width: widget.pageWidth,
      height: widget.pageHeight,
    );

  }

}
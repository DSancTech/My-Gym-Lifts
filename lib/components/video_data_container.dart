import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';

class VideoDataContainer extends StatefulWidget {
  const VideoDataContainer({Key? key, required this.percentage, required this.editButtonAction, required this.shareVideo, required this.name, required this.pr, required this.lbs, required this.kg, required this.reps, required this.rpe, required this.rir, required this.description, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final String name;
  final bool pr;
  final double lbs;
  final double kg;
  final int reps;
  final int rpe;
  final int rir;
  final double percentage;
  final String description;

  final VoidCallback shareVideo;
  final VoidCallback editButtonAction;

  @override
  VideoDataContainerState createState() => VideoDataContainerState();

}

class VideoDataContainerState extends State<VideoDataContainer> with RouteAware {

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

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Sub Text Style
    var subTextStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: extraSmallFontSize,
      fontWeight: regularWeight,
      color: whiteColor.withOpacity(0.4),
      decoration: TextDecoration.none,
    );

    /// Main Text Style
    var mainTextStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: regularFontSize,
      fontWeight: semiBoldWeight,
      color: whiteColor,
      decoration: TextDecoration.none,
    );

    /// Edit Button Container
    var editButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          editIconData,
          size: 14.0,
          color: whiteColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () => widget.editButtonAction(),
      ),
      width: 40.0,
      height: 40.0,
    );

    /// Name Container
    var nameContainer = SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16.0,),
              Text(
                'Exercise',
                style: subTextStyle,
              ),
              const Expanded(child: SizedBox()),
              editButtonContainer,
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
          const SizedBox(height: 4.0),
          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 16.0,),
                widget.pr ? Container(
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
                  margin: const EdgeInsets.only(right: 8.0),
                ) : const SizedBox(),
                Expanded(
                  child: AutoSizeText(
                    widget.name,
                    style: mainTextStyle,
                    minFontSize: smallFontSize,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 16.0,),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    /// Weight Container
    var weightContainer = Container(
      child: Column(
        children: [
          Text(
            'Weight',
            style: subTextStyle,
          ),
          const SizedBox(height: 4.0,),
          AutoSizeText(
            "${widget.lbs} lbs / ${widget.kg} kg",
            style: mainTextStyle,
            minFontSize: smallFontSize,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    );

    /// Reps Container
    var repsContainer = Container(
      child: Column(
        children: [
          Text(
            'Reps',
            style: subTextStyle,
          ),
          const SizedBox(height: 4.0,),
          AutoSizeText(
            "${widget.reps} Reps",
            style: mainTextStyle,
            minFontSize: smallFontSize,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    );

    /// Difficulty Container
    var difficultyContainer = Container(
      child: Column(
        children: [
          Text(
            'Difficulty',
            style: subTextStyle,
          ),
          const SizedBox(height: 4.0),
          AutoSizeText(
            "RPE ${widget.rpe} / ${widget.rir} RIR${(widget.percentage != 0.0) ? " / ${widget.percentage}%" : ""}",
            style: mainTextStyle,
            minFontSize: smallFontSize,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    );

    /// Notes Container
    var notesContainer = (widget.description.isNotEmpty) ? Container(
      child: Column(
        children: [
          Text(
            'Notes',
            style: subTextStyle,
          ),
          const SizedBox(height: 4.0,),
          AutoSizeText(
            widget.description,
            style: mainTextStyle,
            minFontSize: smallFontSize,
            maxLines: 10,
            textAlign: TextAlign.left,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    ) : const SizedBox();

    /// Share Button Container
    var shareButtonContainer = SizedBox(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            child: const Text(
              'Share Video',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: smallFontSize,
                fontWeight: semiBoldWeight,
                decoration: TextDecoration.none,
                color: whiteColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onPrimary: lightBlueColor,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => widget.shareVideo(),
          ),
          height: 40.0,
          width: 120.0,
          margin: const EdgeInsets.only(right: 16.0, top: 32.0),
        ),
      ),
    );

    /// Main Container
    return SizedBox(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, (widget.bottomSafeArea + 24.0)),
        children: [
          nameContainer,
          weightContainer,
          repsContainer,
          difficultyContainer,
          notesContainer,
          shareButtonContainer,
        ],
      ),
    );

  }

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:my_gym_lifts/components/shared.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:my_gym_lifts/components/video_thumbnail_container.dart';
import 'package:my_gym_lifts/components/video_data_container.dart';
import 'package:my_gym_lifts/components/video_data_editing_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_gym_lifts/screens/video_player_screen.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:dismissible_page/dismissible_page.dart';

class VideoDataScreen extends StatefulWidget {
  const VideoDataScreen({Key? key, required this.index, required this.dismissDown, required this.newVideo, required this.reloadData, required this.appDocsDir, required this.videoData}) : super(key: key);

  final Directory appDocsDir;
  final Map<String,dynamic> videoData;
  final int index;

  final bool newVideo;
  final bool dismissDown;

  final VoidCallback reloadData;

  @override
  VideoDataScreenState createState() => VideoDataScreenState();
}

class VideoDataScreenState extends State<VideoDataScreen> with RouteAware, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> videoDataScreenScaffoldKey = GlobalKey<ScaffoldState>();

//  /// Video Data Variables
//  String name = "";
//  bool pr = false;
//  double lbs = 0.0;
//  double kg = 0.0;
//  int reps = 0;
//  int rpe = 0;
//  int rir = 10;
//  DateTime date = DateTime.now();
//  String duration = "";
//  Uint8List? thumb;
//  dynamic videoAssetEntity = "";
//  String description = "";
//  String keywords = "";

  /// Editing if pressed Edit or if New Video
  bool isEditing = false;
  bool isEdited = false;

  /// Video Data Editing Variables
  String newName = "";
  FocusNode nameTextFieldFocusNode = FocusNode();
  TextEditingController nameTextFieldController = TextEditingController();
  bool newPr = false;
  double newLbs = 0.0;
  FocusNode lbsTextFieldFocusNode = FocusNode();
  TextEditingController lbsTextFieldController = TextEditingController();
  double newKg = 0.0;
  FocusNode kgTextFieldFocusNode = FocusNode();
  TextEditingController kgTextFieldController = TextEditingController();
  int newReps = 0;
  FocusNode repsTextFieldFocusNode = FocusNode();
  TextEditingController repsTextFieldController = TextEditingController();
  int newRpe = 0;
  FocusNode rpeTextFieldFocusNode = FocusNode();
  TextEditingController rpeTextFieldController = TextEditingController();
  int newRir = 10;
  FocusNode rirTextFieldFocusNode = FocusNode();
  TextEditingController rirTextFieldController = TextEditingController();
  double newPercentage = 0.0;
  FocusNode percentageTextFieldFocusNode = FocusNode();
  TextEditingController percentageTextFieldController = TextEditingController();
  String newDescription = "";
  FocusNode descriptionTextFieldFocusNode = FocusNode();
  TextEditingController descriptionTextFieldController = TextEditingController();
  String newKeywords = "";

  /// Loading
  bool isLoading = false;

  /// Init State
  @override
  void initState() {
    super.initState();

    if (widget.newVideo == true) {

    }
    else {
      setState(() {
        newPr = widget.videoData["pr"];
      });
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

    /// Keyboard Open
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool keyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0.0);

    /// ThumbnailContainer
    var thumbnailContainer = AnimatedPositioned(
      child: VideoThumbnailContainer(
        pageWidth: pageWidth,
        pageHeight: pageHeight,
        topSafeArea: topSafeArea,
        bottomSafeArea: bottomSafeArea,
        isOpened: true,
        isEditing: isEditing,
        newVideo: widget.newVideo,
        mainButtonAction: keyboardOpen ? () => closeKeyboard() : () => thumbnailMainButtonAction(context),
        backButtonAction: () => thumbnailBackButtonAction(context),
        videoData: widget.videoData,
      ),
      left: 0.0,
      right: 0.0,
      top: keyboardOpen ? -(keyboardHeight / 2.0) : 0.0,
      height: (topSafeArea + (pageHeight / 4.0)),
      duration: keyboardOpen ? const Duration(milliseconds: 0) : const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Detail Container
    var detailContainer = AnimatedPositioned(
      child: VideoDataContainer(
        pageWidth: pageWidth,
        pageHeight: pageHeight,
        topSafeArea: topSafeArea,
        bottomSafeArea: bottomSafeArea,
        name: widget.newVideo ? "" : (isEdited ? newName : widget.videoData["name"]),
        pr: widget.newVideo ? false : (isEdited ? newPr : widget.videoData["pr"]),
        lbs: widget.newVideo ? 0.0 : (isEdited ? newLbs : widget.videoData["lbs"]),
        kg: widget.newVideo ? 0.0 : (isEdited ? newKg : widget.videoData["kg"]),
        reps: widget.newVideo ? 0 : (isEdited ? newReps : widget.videoData["reps"]),
        rpe: widget.newVideo ? 0 : (isEdited ? newRpe : widget.videoData["rpe"]),
        rir: widget.newVideo ? 10 : (isEdited ? newRir : widget.videoData["rir"]),
        percentage: widget.newVideo? 0.0 : (isEdited ? newPercentage : widget.videoData["percentage"]),
        description: widget.newVideo ? "" : (isEdited ? newDescription : widget.videoData["description"]),
        shareVideo: () => shareVideo(),
        editButtonAction: () => editButtonAction(),
      ),
      width: pageWidth,
      top: (topSafeArea + (pageHeight / 4)),
      bottom: 0.0,
      left: ((isEditing == false) && (widget.newVideo == false)) ? 0.0 : -pageWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Edit Container
    var editContainer = AnimatedPositioned(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          child: VideoDataEditingContainer(
            pageWidth: pageWidth,
            pageHeight: pageHeight,
            topSafeArea: topSafeArea,
            bottomSafeArea: bottomSafeArea,
            keyboardOpen: keyboardOpen,
            keyboardHeight: keyboardHeight,
            name: widget.videoData["name"],
            nameChanged: (name) => nameChanged(name),
            nameTextFieldFocusNode: nameTextFieldFocusNode,
            nameTextFieldController: nameTextFieldController,
            nameTextFieldAction: () => nameTextFieldAction(),
            pr: newPr,
            prChanged: () => prChanged(),
            lbs: widget.videoData["lbs"],
            lbsTextFieldFocusNode: lbsTextFieldFocusNode,
            lbsTextFieldController: lbsTextFieldController,
            lbsChanged: (lbs) => lbsChanged(lbs),
            kg: widget.videoData["kg"],
            kgTextFieldFocusNode: kgTextFieldFocusNode,
            kgTextFieldController: kgTextFieldController,
            kgChanged: (kg) => kgChanged(kg),
            weightTextFieldsAction: () => weightTextFieldsAction(),
            percentage: widget.videoData["percentage"],
            percentageTextFieldFocusNode: percentageTextFieldFocusNode,
            percentageTextFieldController: percentageTextFieldController,
            percentageChanged: (percentage) => percentageChanged(percentage),
            reps: widget.videoData["reps"],
            repsTextFieldFocusNode: repsTextFieldFocusNode,
            repsTextFieldController: repsTextFieldController,
            repsChanged: (reps) => repsChanged(reps),
            repsTextFieldAction: () => repsTextFieldAction(),
            rpe: widget.videoData["rpe"],
            rpeTextFieldController: rpeTextFieldController,
            rpeTextFieldFocusNode: rpeTextFieldFocusNode,
            rpeChanged: (rpe) => rpeChanged(rpe),
            rir: widget.videoData["rir"],
            rirTextFieldFocusNode: rirTextFieldFocusNode,
            rirTextFieldController: rirTextFieldController,
            rirChanged: (rir) => rirChanged(rir),
            difficultyTextFieldsAction: () => difficultyTextFieldsAction(),
            description: widget.videoData["description"],
            descriptionChanged: (description) => descriptionChanged(description),
            descriptionTextFieldFocusNode: descriptionTextFieldFocusNode,
            descriptionTextFieldController: descriptionTextFieldController,
            descriptionTextFieldAction: () => descriptionTextFieldAction(),
            cancelButtonAction: () => editingCancelButtonAction(context),
            deleteButtonAction: () => deleteButtonAction(context),
            newVideo: widget.newVideo,
          ),
          onTap: keyboardOpen ? () => closeKeyboard() : null,
        ),
      ),
      width: pageWidth,
      top: keyboardOpen ? ((topSafeArea + (pageHeight / 4.0)) - (keyboardHeight / 2.0)) : (topSafeArea + (pageHeight / 4.0)),
      bottom: keyboardOpen ? bottomSafeArea : (bottomSafeArea + 50.0),
      right: (isEditing || widget.newVideo) ? 0.0 : -pageWidth,
      duration: keyboardOpen ? const Duration(milliseconds: 0) : const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Save Button Container
    var saveButtonContainer = AnimatedPositioned(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [lightBlueColor, darkBlueColor],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: ElevatedButton(
          child: const Text(
            'Save',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: regularFontSize,
              fontWeight: boldWeight,
              decoration: TextDecoration.none,
              color: whiteColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: lightBlueColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 0.0,
            padding: EdgeInsets.only(bottom: bottomSafeArea / 2.0),
          ),
          onPressed: () => saveButtonAction(context),
        ),
      ),
      left: 0.0,
      right: 0.0,
      height: (bottomSafeArea + 50.0),
      bottom: keyboardOpen ? (-(bottomSafeArea + 50.0)) : ((isEditing || widget.newVideo) ? 0.0 : -(bottomSafeArea + 50.0)),
      duration: keyboardOpen ? const Duration(milliseconds: 0) : const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Close KeyboardButtonContainer
    var closeKeyboardButtonContainer = AnimatedPositioned(
      child: Container(
        decoration: BoxDecoration(
          color: darkBlueColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: ElevatedButton(
          child: const Icon(
            Icons.check_rounded,
            size: 24.0,
            color: whiteColor,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: blackColor,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            elevation: 0.0,
            padding: EdgeInsets.only(bottom: bottomSafeArea / 2.0),
          ),
          onPressed: () => closeKeyboard(),
        ),
      ),
      right: keyboardOpen ? 12.0 : - 62.0,
      bottom: keyboardHeight + 12.0,
      width: 50.0,
      height: 50.0,
      duration: keyboardOpen ? const Duration(milliseconds: 0) : const Duration(milliseconds: 300),
      curve: Curves.easeInOutExpo,
    );

    /// Body Container
    var bodyContainer = Container(
      color: lightGrayColor,
      child: Stack(
        children: [
          detailContainer,
          editContainer,
          thumbnailContainer,
          saveButtonContainer,
          closeKeyboardButtonContainer,
        ],
        alignment: Alignment.center,
      ),
      width: pageWidth,
      height: pageHeight,
    );

    /// Scaffold
    return (widget.newVideo && (widget.dismissDown == false)) ? Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightGrayColor,
      key: videoDataScreenScaffoldKey,
      body: bodyContainer,
    ) : DismissiblePage(
      onDismiss: () => Navigator.of(context).pop(),
      isFullScreen: true,
      dragSensitivity: .4,
      maxTransformValue: 4,
      direction: DismissDirection.vertical,
      child: bodyContainer,
    );

  }

  /// Close Keyboard
  void closeKeyboard() {
    if (nameTextFieldFocusNode.hasFocus) {
      nameTextFieldFocusNode.unfocus();
    }
    else if (lbsTextFieldFocusNode.hasFocus) {
      lbsTextFieldFocusNode.unfocus();
    }
    else if (kgTextFieldFocusNode.hasFocus) {
      kgTextFieldFocusNode.unfocus();
    }
    else if (repsTextFieldFocusNode.hasFocus) {
      repsTextFieldFocusNode.unfocus();
    }
    else if (rpeTextFieldFocusNode.hasFocus) {
      rpeTextFieldFocusNode.unfocus();
    }
    else if (rirTextFieldFocusNode.hasFocus) {
      rirTextFieldFocusNode.unfocus();
    }
    else if (descriptionTextFieldFocusNode.hasFocus) {
      descriptionTextFieldFocusNode.unfocus();
    }
  }

  /// Thumbnail Main Button Action
  void thumbnailMainButtonAction(BuildContext context) async {
    var entity = await AssetEntity.fromId(widget.videoData["asset_entity"]);
    if (entity != null) {
      var route = PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return VideoPlayerScreen(
            appDocsDir: widget.appDocsDir,
            entity: entity,
            thumb: widget.videoData["thumb"],
            name: widget.videoData["name"],
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

      if (result == "Error") {
        // TODO: Delete from file and display error.
      }
    }
    else {
      // TODO: Error
    }
  }
  
  /// Editing Cancel Button Action
  void editingCancelButtonAction(context) async {
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
      desc: "Any unsaved info will be lost.",
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

    final result = await cancelAlert.show();
    if (result == true) {
      setState(() {
        isEditing = false;
      });
    }
  }

  /// Delete Button Action
  void deleteButtonAction(BuildContext context) async {
    Alert deleteAlert = Alert(
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
      desc: "This will only delete the video from this app and not from your phone's media library.",
      buttons: [
        DialogButton(
          child: const Text(
            "Yes",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: smallFontSize,
              fontWeight: boldWeight,
              decoration: TextDecoration.none,
              color: lightRedColor,
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

    final result = await deleteAlert.show();
    if (result == true) {
      Navigator.pop(context, "Delete");
    }
  }

  /// Thumbnail Back Button Action
  void thumbnailBackButtonAction(BuildContext context) async {
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
      desc: "Any unsaved info will be lost.",
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

    if (widget.newVideo && (widget.dismissDown == false)) {
      final result = await cancelAlert.show();
      if (result == true) {
        Navigator.pop(context, "Cancel");
      }
    }
    else {
      Navigator.pop(context);
    }
  }

  /// Edit Button Action
  void editButtonAction() {
    newName = widget.videoData["name"];
    nameTextFieldController.text = newName;
    newLbs = widget.videoData["lbs"];
    lbsTextFieldController.text = newLbs.toString();
    newKg = widget.videoData["kg"];
    kgTextFieldController.text = newKg.toString();
    newPercentage = widget.videoData["percentage"];
    percentageTextFieldController.text = newPercentage.toString();
    newReps = widget.videoData["reps"];
    repsTextFieldController.text = newReps.toString();
    newRpe = widget.videoData["rpe"];
    rpeTextFieldController.text = newRpe.toString();
    newRir = widget.videoData["rir"];
    rirTextFieldController.text = newRir.toString();
    newDescription = widget.videoData["description"];
    descriptionTextFieldController.text = newDescription;
    setState(() {
      isEditing = true;
    });
  }

  /// Save Button Action
  void saveButtonAction(BuildContext context) async {
    if (nameTextFieldController.text.isEmpty) {
      nameTextFieldEmpty(context);
    }
    else {
      setState(() {
        isLoading = true;
      });
      DateFormat format = DateFormat.yMMMMd('en_US');
      String newDate = widget.newVideo ? format.format(widget.videoData["date"]) : widget.videoData["date"];
      var newData = {
        "id": widget.videoData["id"],
        "name": newName,
        "pr": newPr,
        "lbs": newLbs,
        "kg": newKg,
        "percentage": newPercentage,
        "reps": newReps,
        "rpe": newRpe,
        "rir": newRir,
        "date": newDate,
        "duration": widget.videoData["duration"],
        "thumb": widget.videoData["thumb"],
        "asset_entity": widget.videoData["asset_entity"],
        "description": newDescription,
        "keywords": "$newName ${(newPr == true) ? "PR" : ""} $newLbs $newKg $newReps $newRpe $newRir $newDate $newDescription",
      };
      final File file = File('${widget.appDocsDir.path}/videosData.json');
      if (await file.exists()) {
        // Map<String,dynamic> videoData = {"data": []};
        Map<String,dynamic> oldVideoData = json.decode(await file.readAsString());
        if (widget.newVideo) {
          oldVideoData["data"].insert(0, newData);
          await file.writeAsString(json.encode(oldVideoData));
          Navigator.pop(context, "Done");
        }
        else {
          oldVideoData["data"][widget.index] = newData;
          await file.writeAsString(json.encode(oldVideoData));
          widget.reloadData();
          setState(() {
            isEdited = true;
            isLoading = false;
            isEditing = false;
          });
        }
      }
      else {
        // TODO: Show error, maybe? Maybe not needed.
        setState(() {
          isLoading = false;
          isEditing = false;
        });
      }
    }
  }

  /// Name Changed
  void nameChanged(String nameString) {
    setState(() {
      newName = nameString;
    });
  }

  /// Name Text Field Empty
  void nameTextFieldEmpty(BuildContext context) {
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
      title: "Missing Something!",
      desc: "Please fill out the exercise name to continue.",
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
    errorAlert.show();
  }

  /// Name Text Field Action
  void nameTextFieldAction() {
    nameTextFieldFocusNode.unfocus();
    lbsTextFieldFocusNode.requestFocus();
  }

  /// PR Changed
  void prChanged() {
    setState(() {
      newPr = !newPr;
    });
  }

  /// lbs Changed
  void lbsChanged(double lbsDouble) {
    // 1 lb = 0.453592 kg
    double kgConversion = lbsDouble * 0.453592;
    kgTextFieldController.text = kgConversion.toStringAsFixed(2);
    setState(() {
      newLbs = double.parse(lbsDouble.toStringAsFixed(2));
      newKg = double.parse(kgConversion.toStringAsFixed(2));
    });
  }

  /// kg Changed
  void kgChanged(double kgDouble) {
    // 1 kg = 2.20462 lbs
    double lbsConversion = kgDouble * 2.20462;
    lbsTextFieldController.text = lbsConversion.toStringAsFixed(2);
    setState(() {
      newKg = double.parse(kgDouble.toStringAsFixed(2));
      newLbs = double.parse(lbsConversion.toStringAsFixed(2));
    });
  }

  /// Weight Text Fields Action
  void weightTextFieldsAction() {
    if (lbsTextFieldFocusNode.hasFocus) {
      lbsTextFieldFocusNode.unfocus();
    }
    else {
      kgTextFieldFocusNode.unfocus();
    }
    repsTextFieldFocusNode.requestFocus();
  }

  /// Reps Changed
  void repsChanged(int repsInt) {
    setState(() {
      newReps = repsInt;
    });
  }

  /// Reps Text Field Action
  void repsTextFieldAction() {
    repsTextFieldFocusNode.unfocus();
    rpeTextFieldFocusNode.requestFocus();
  }

  /// RPE Changed
  void rpeChanged(int rpeInt) {
    int rirConversion = 10 - rpeInt;
    rirTextFieldController.text = rirConversion.toString();
    setState(() {
      newRpe = rpeInt;
      newRir = rirConversion;
    });
  }

  /// RIR Changed
  void rirChanged(int rirInt) {
    int rpeConversion = 10 - rirInt;
    rpeTextFieldController.text = rpeConversion.toString();
    setState(() {
      newRir = rirInt;
      newRpe = rpeConversion;
    });
  }

  /// Percentage Changed
  void percentageChanged(double percentageDouble) {
    setState(() {
      newPercentage = percentageDouble;
    });
  }

  /// Difficulty Text Fields Action
  void difficultyTextFieldsAction() {
    if (rpeTextFieldFocusNode.hasFocus) {
      rpeTextFieldFocusNode.unfocus();
    }
    else if (rirTextFieldFocusNode.hasFocus) {
      rirTextFieldFocusNode.unfocus();
    }
    else {
      percentageTextFieldFocusNode.unfocus();
    }
    descriptionTextFieldFocusNode.requestFocus();
  }

  /// Description Changed
  void descriptionChanged(String descriptionString) {
    setState(() {
      newDescription = descriptionString;
    });
  }

  /// Description Text Field Action
  void descriptionTextFieldAction() {
    descriptionTextFieldFocusNode.unfocus();
  }

  /// Share Video
  void shareVideo() async {
    var entity = await AssetEntity.fromId(widget.videoData["asset_entity"]);
    if (entity != null) {
      var file = await entity.file;
      if (file != null) {
        // TODO: INCLUDE ABILITY TO ADD MULTIPLE VIDEOS AT ONCE
        List<String> filePath = [file.path];
        await Share.shareFiles(filePath,
//          subject: widget.videoData["name"],
          text: widget.videoData["name"],
        );
      }
    }
  }

}
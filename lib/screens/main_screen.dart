import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:my_gym_lifts/screens/video_library_screen.dart';
import 'package:my_gym_lifts/components/main_screen_bottom_bar_container.dart';
import 'package:my_gym_lifts/components/main_screen_top_bar_container.dart';
import 'package:my_gym_lifts/components/main_screen_search_bar_container.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:after_layout/after_layout.dart';
import 'package:my_gym_lifts/components/main_icon.dart';
import 'package:my_gym_lifts/components/speech_to_text_overlay_container.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:my_gym_lifts/screens/camera_screen.dart';
import 'package:my_gym_lifts/components/reveal_route.dart';
import 'package:my_gym_lifts/components/main_screen_media_button_container.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:my_gym_lifts/components/main_screen_list_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:my_gym_lifts/screens/video_data_screen.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.oniOS, required this.appDocsDir}) : super(key: key);

  final bool oniOS;
  final Directory appDocsDir;

  @override
  MainScreenState createState() => MainScreenState();

}

class MainScreenState extends State<MainScreen> with RouteAware, AfterLayoutMixin<MainScreen>, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> mainScreenScaffoldKey = GlobalKey<ScaffoldState>();

  /// Search Text Field
  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();
  String searchTextFieldString = '';
  final SpeechToText speech = SpeechToText();
  bool showSpeechToText = false;
  bool speechNeedsInit = true;
  bool hasSpeech = false;
  String speechRecognizedWords = "";

  /// Video Data
  Map<String, dynamic> videoData = {"data":[]};
  Map<String, dynamic> searchData = {"data": []};
  bool isLoading = true;
  bool isSearching = false;

  /// Init State
  @override
  void initState() {
    super.initState();

    loadVideoData();
  }

  /// Load Video Data
  loadVideoData() async {
    final File file = File('${widget.appDocsDir.path}/videosData.json');
    if (await file.exists()) {
      Map<String, dynamic> loadedVideoData = await json.decode(await file.readAsString());
      List<int> needsRemoving = [];
      if (loadedVideoData["data"].isNotEmpty) {
        // Thumb is saved as List<dynamic> in file, must convert to Uint8List to be used in MemoryImage
        for(var i = 0; i < loadedVideoData["data"].length; i++){
          var entity = await AssetEntity.fromId(loadedVideoData["data"][i]["asset_entity"]).catchError((error){
            if (needsRemoving.contains(i) == false) {
              needsRemoving.add(i);
            }
          });
          if (entity != null) {
            var exists = await entity.exists;
            if (exists) {
              List<int> intList = loadedVideoData["data"][i]["thumb"].cast<int>().toList();
              Uint8List data = Uint8List.fromList(intList);
              loadedVideoData["data"][i].update('thumb', (value) => data);
            }
            else {
              if (needsRemoving.contains(i) == false) {
                needsRemoving.add(i);
              }
            }
          }
          else {
            if (needsRemoving.contains(i) == false) {
              needsRemoving.add(i);
            }
          }
          if (i == (loadedVideoData["data"].length - 1)) {
            if (needsRemoving.isEmpty) {
              setState(() {
                videoData = loadedVideoData;
                isLoading = false;
              });
            }
            else {
              videoData = loadedVideoData;
              removeVideos(needsRemoving);
            }
          }
        }
      }
      else {
        setState(() {
          videoData = loadedVideoData;
          isLoading = false;
        });
      }
    }
  }

  /// Needs Removing
  void removeVideos(List<int> needsRemoving) async {
    Map<String, dynamic> newVideoData = videoData;
    for(var i = 0; i < needsRemoving.length; i++){
      newVideoData["data"].removeAt(needsRemoving[i]);
      if (i == (needsRemoving.length - 1)) {
        final File file = File('${widget.appDocsDir.path}/videosData.json');
        if (await file.exists()) {
          await file.writeAsString(json.encode(newVideoData));
          reloadVideosData();
        }
        else {
          // TODO: Show error, maybe? Maybe not needed.
        }
      }
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

    /// Keyboard Open
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool keyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0.0);

    /// Top Bar Container
    var topBarContainer = Positioned(
      child: MainScreenTopBarContainer(
        pageHeight: pageHeight,
        pageWidth: pageWidth,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      height: (topSafeArea + 73.0),
    );

    /// Search Bar Container
    var searchBarContainer = Positioned(
      child: MainScreenSearchBarContainer(
        pageHeight: pageHeight,
        pageWidth: pageWidth,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
        searchTextFieldController: searchTextFieldController,
        searchTextFieldFocusNode: searchTextFieldFocusNode,
        searchTextFieldString: searchTextFieldString,
        searchTextFieldAction: () {
          searchTextFieldFocusNode.unfocus();
        },
        searchTextFieldClear: () {
          searchTextFieldController.clear();
          setState(() {
            searchTextFieldString = '';
            isSearching = false;
          });
        },
        searchTextFieldDidChange: (text) => searchVideos(text),
        searchByVoice: () async => openSearchByVoice(context),
      ),
      left: 12.0,
      right: 12.0,
      top: (topSafeArea + 12.0),
      height: 45.0,
    );

    /// Bottom Bar Container
    var bottomBarContainer = Positioned(
      child: MainScreenBottomBarContainer(
        pageHeight: pageHeight,
        pageWidth: pageWidth,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
      ),
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      height: (bottomSafeArea + 70.0),
    );

    /// Main Icon Image Container
    var mainIconImageContainer = Positioned(
      child: MainIcon(
        pageWidth: pageWidth,
        pageHeight: pageHeight,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
        hasColor: true,
        useHero: true,
        useIcon: true,
        mainButtonAction: () => openCamera(pageHeight + topSafeArea),
      ),
      width: 90.0,
      height: 90.0,
      bottom: (bottomSafeArea),
    );

    /// Main Container
    var mainContainer = Positioned(
      child: SizedBox(
        child: GestureDetector(
          child: MainScreenListContainer(
            pageWidth: pageWidth,
            pageHeight: pageHeight,
            bottomSafeArea: bottomSafeArea,
            topSafeArea: topSafeArea,
            keyboardOpen: keyboardOpen,
            keyboardHeight: keyboardHeight,
            videoData: isSearching ? searchData : videoData,
            isLoading: isLoading,
            reloadData: () => reloadVideosData(),
            openVideo: (index) => openVideo(context, index),
          ),
          onTap: () {
            if (searchTextFieldFocusNode.hasFocus) {
              searchTextFieldFocusNode.unfocus();
            }
          },
        ),
      ),
      left: 0.0,
      right: 0.0,
      top: (topSafeArea + 73.0),
      bottom: (bottomSafeArea + 70.0),
    );

    /// Speech To Text Overlay Container
    var speechToTextOverlayContainer = Positioned(
      child: IgnorePointer(
        child: AnimatedOpacity(
          child: showSpeechToText ? SpeechToTextOverlayContainer(
            pageWidth: pageWidth,
            pageHeight: pageHeight,
            bottomSafeArea: bottomSafeArea,
            topSafeArea: topSafeArea,
            recognizedText: speechRecognizedWords,
            cancelAction: () {
              setState(() {
                showSpeechToText = false;
              });
              stopListening();
            },
            acceptAction: () async {
              searchTextFieldController.text = speechRecognizedWords;
              setState(() {
                searchTextFieldString = speechRecognizedWords;
                showSpeechToText = false;
              });
              stopListening();
              searchVideos(speechRecognizedWords);
            },
          ) : const SizedBox(width: 0.0,),
          opacity: showSpeechToText ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
        ),
        ignoring: showSpeechToText ? false : true,
      ),
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
    );

    /// Media Button Container
    var mediaButtonContainer = Positioned(
      child: MainScreenMediaButtonContainer(
        pageHeight: pageHeight,
        pageWidth: pageWidth,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
        buttonAction: () => mediaPickerAction(context, pageWidth),
      ),
      width: (pageWidth / 2.0),
      height: 70.0,
      bottom: bottomSafeArea,
      right: 0.0,
    );

    /// Scaffold
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkGrayColor,
        key: mainScreenScaffoldKey,
        body: SizedBox(
          child: Stack(
            children: [
              mainContainer,
              topBarContainer,
              searchBarContainer,
              bottomBarContainer,
              mediaButtonContainer,
              mainIconImageContainer,
              speechToTextOverlayContainer,
            ],
            alignment: Alignment.center,
          ),
          width: pageWidth,
          height: pageHeight,
        ),
      ),
    );

  }

  /// Open Search By Voice
  void openSearchByVoice(BuildContext context) async {
    if (searchTextFieldFocusNode.hasFocus) {
      searchTextFieldFocusNode.unfocus();
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.speech,
    ].request();
    if ((statuses[Permission.microphone] == PermissionStatus.granted) &&  (statuses[Permission.speech] == PermissionStatus.granted)) {
      if (speechNeedsInit) {
        await initSpeechState();
      }
      if (hasSpeech) {
        setState(() {
          speechRecognizedWords = "";
          showSpeechToText = true;
        });
        startListening();
      }
    }
    else {
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
        desc: "Looks like there is an error accessing the mic. Please check your phone's permission settings.",
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
  }

  /// Init Speech State
  Future<void> initSpeechState() async {
    bool hasSpeechBool = await speech.initialize(onError: errorListener, onStatus: statusListener );
    if (!mounted) return;
    setState(() {
      hasSpeech = hasSpeechBool;
    });
  }

  /// Start Listening
  void startListening() {
    speech.listen(onResult: resultListener);
//    print(resultListener);
    setState(() {

    });
  }

  /// Stop Listening
  void stopListening() {
    speech.stop( );
    setState(() {

    });
  }

  /// Cancel Listening
  void cancelListening() {
    speech.cancel( );
    setState(() {

    });
  }

  /// Result Listener
  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      speechRecognizedWords = result.recognizedWords;
    });
//    print(speechRecognizedWords);
  }

  /// Error Listener
  void errorListener(SpeechRecognitionError error ) {
//    print("${error.errorMsg} - ${error.permanent}");
  }

  /// Status Listener
  void statusListener(String status ) {
//    print("$status");
  }

  /// Open Camera
  void openCamera(double pageHeight) async {
    if (searchTextFieldFocusNode.hasFocus) {
      searchTextFieldFocusNode.unfocus();
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.granted) {
      bool audioGranted = await Permission.microphone.isGranted;

      final result = await Navigator.push(
        context,
        RevealRoute(
          page: CameraScreen(
            audioHasPermission: audioGranted,
            appDocsDir: widget.appDocsDir,
          ),
          maxRadius: pageHeight,
          centerAlignment: Alignment.bottomCenter,
        ),
      );

      if (result == "Refresh") {
        reloadVideosData();
      }

    }
    else {
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
        desc: r"Looks like there is an error accessing your camera. Please check your phone's permission settings.",
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
  }
  
  /// Media Picker Action
  void mediaPickerAction(BuildContext context, double pageWidth) async {
    if (searchTextFieldFocusNode.hasFocus) {
      searchTextFieldFocusNode.unfocus();
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
    ].request();
    if (statuses[Permission.photos] == PermissionStatus.granted) {
      List<Map<String, dynamic>> data = [];
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList(type: RequestType.video);
      for(var i = 0; i < list.length; i++) {
        List<AssetEntity> videoList = await list[i].assetList;
        data.add({
          "name": list[i].name,
          "id": list[i].id,
          "asset_count": list[i].assetCount,
          "asset_list": videoList,
        });
      }
      var route = PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return VideoLibraryScreen(
            appDocsDir: widget.appDocsDir,
            mainData: data,
            pageWidth: pageWidth,
            videosData: videoData["data"],
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

      if (result == "Refresh") {
        reloadVideosData();
      }
    }
  }

  /// Open Video
  void openVideo(BuildContext context, int index) async {
    if (searchTextFieldFocusNode.hasFocus) {
      searchTextFieldFocusNode.unfocus();
    }
    var route = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return VideoDataScreen(
          appDocsDir: widget.appDocsDir,
          videoData: isSearching ? searchData["data"][index] : videoData["data"][index],
          index: index,
          newVideo: false,
          dismissDown: true,
          reloadData: () => reloadVideosData(),
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.linear,
              reverseCurve: Curves.linear,
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

    if (result == "Refresh") {
      reloadVideosData();
    }
    else if (result == "Delete") {
      deleteVideo(context, index);
    }
  }

  /// Delete Video
  void deleteVideo(BuildContext context, int index) async {
    videoData["data"].removeAt(index);
    setState(() {
      isLoading = true;
    });
    final File file = File('${widget.appDocsDir.path}/videosData.json');
    if (await file.exists()) {
      await file.writeAsString(json.encode(videoData));
      reloadVideosData();
    }
    else {
      // TODO: Show error, maybe? Maybe not needed.
    }
  }

  /// Reload Videos Data
  void reloadVideosData() async {
    setState(() {
      isLoading = true;
    });
    if (searchTextFieldFocusNode.hasFocus) {
      searchTextFieldFocusNode.unfocus();
    }
    if (searchTextFieldString.isNotEmpty) {
      searchTextFieldString = "";
      searchTextFieldController.clear();
      isSearching = false;
      searchData = {"data": []};
    }
    final File file = File('${widget.appDocsDir.path}/videosData.json');
    if (await file.exists()) {
      Map<String, dynamic> loadedVideoData = await json.decode(await file.readAsString());
      if (loadedVideoData["data"].isNotEmpty) {
        // Thumb is saved as List<dynamic> in file, must convert to Uint8List to be used in MemoryImage
        for(var i = 0; i < loadedVideoData["data"].length; i++){
          List<int> intList = loadedVideoData["data"][i]["thumb"].cast<int>().toList();
          Uint8List data = Uint8List.fromList(intList);
          loadedVideoData["data"][i].update('thumb', (value) => data);
          if (i == (loadedVideoData["data"].length - 1)) {
            setState(() {
              videoData = loadedVideoData;
              isLoading = false;
            });
          }
        }
      }
      else {
        setState(() {
          videoData = loadedVideoData;
          isLoading = false;
        });
      }
    }
  }

  /// Search Videos
  void searchVideos(String text) async {
    if (isLoading == false) {
      searchData = {"data": []};
      setState(() {
        searchTextFieldString = text;
      });
      if (text.isNotEmpty) {
        await videoData["data"].forEach((video) {
          String keywords = video["keywords"].toLowerCase();
          List<bool> wordsContains = [];
          int numberOfWords = 0;
          text.toLowerCase().split(" ").forEach((word) {
            numberOfWords++;
            if (keywords.contains(word)) {
              wordsContains.add(true);
            }
          });
//          print(numberOfWords);
//          print("SEARCH TEXT: $text");
//          print("DESCRIPTION: ${video["description"]}");
//          print("${video["name"]} $wordsContains");
          if (wordsContains.every((element) => true) && (wordsContains.length == numberOfWords)) {
            searchData["data"].insert(0, video);
          }
//          if (keywords.contains(text.toLowerCase())) {
//            searchData["data"].insert(0, video);
//          }
        });
        isSearching = true;
        setState(() {});
      }
      else {
        isSearching = false;
        searchData = {"data": []};
        setState(() {});
      }
    }
  }

}
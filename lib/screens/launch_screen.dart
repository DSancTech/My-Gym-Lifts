import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:my_gym_lifts/screens/main_screen.dart';
import 'package:my_gym_lifts/components/main_screen_bottom_bar_container.dart';
import 'package:my_gym_lifts/components/main_screen_top_bar_container.dart';
import 'package:my_gym_lifts/components/main_screen_search_bar_container.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:after_layout/after_layout.dart';
import 'package:my_gym_lifts/components/main_icon.dart';
import 'package:my_gym_lifts/components/main_screen_media_button_container.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:typed_data';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key, required this.oniOS, required this.appDocsDir}) : super(key: key);

  final bool oniOS;
  final Directory appDocsDir;

  @override
  LaunchScreenState createState() => LaunchScreenState();

}

class LaunchScreenState extends State<LaunchScreen> with RouteAware, AfterLayoutMixin<LaunchScreen>, TickerProviderStateMixin {

  /// Scaffold Key
  final GlobalKey<ScaffoldState> launchScreenScaffoldKey = GlobalKey<ScaffoldState>();

  /// Search Text Field
  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();
  String searchTextFieldString = '';

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
    beginTransition() async {
      await Future.delayed(const Duration(milliseconds: 200));
      openMainScreen();
    }
    beginTransition();
  }

  /// Open Main Screen
  void openMainScreen() async {
    var route = PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return MainScreen(
          oniOS: widget.oniOS,
          appDocsDir: widget.appDocsDir,
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
      transitionDuration: const Duration(milliseconds: 2000),
    );

    await Navigator.push(
      context,
      route,
    );
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
      height: (pageHeight / 2.0),
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

        },
        searchTextFieldClear: () {

        },
        searchTextFieldDidChange: (text) {

        },
        searchByVoice: () {

        },
      ),
      left: 12.0,
      right: 12.0,
      top: -(pageHeight / 4.0),
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
      height: (pageHeight / 2.0),
    );

    /// Media Button Container
    var mediaButtonContainer = Positioned(
      child: MainScreenMediaButtonContainer(
        pageHeight: pageHeight,
        pageWidth: pageWidth,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
        buttonAction: () {

        },
      ),
      width: (pageWidth / 2.0),
      height: 70.0,
      bottom: bottomSafeArea,
      right: -(pageWidth),
    );

    /// Launch Icon Image Container
    var launchIconImageContainer = SizedBox(
      child: MainIcon(
        pageWidth: pageWidth,
        pageHeight: pageHeight,
        bottomSafeArea: bottomSafeArea,
        topSafeArea: topSafeArea,
        hasColor: true,
        useHero: true,
        useIcon: false,
        mainButtonAction: () {

        },
      ),
      width: (pageWidth - 148.0),
      height: (pageWidth - 148.0),
    );

    /// Scaffold
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkGrayColor,
      key: launchScreenScaffoldKey,
      body: SizedBox(
        child: Stack(
          children: [
            topBarContainer,
            bottomBarContainer,
            mediaButtonContainer,
            searchBarContainer,
            launchIconImageContainer,
          ],
          alignment: Alignment.center,
        ),
        width: pageWidth,
        height: pageHeight,
      ),
    );

  }

}
import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';

class MainScreenBottomBarContainer extends StatefulWidget {
  const MainScreenBottomBarContainer({Key? key, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  @override
  MainScreenBottomBarContainerState createState() => MainScreenBottomBarContainerState();

}

class MainScreenBottomBarContainerState extends State<MainScreenBottomBarContainer> with RouteAware {

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

    /// Main Container
    return Hero(
      child: Container(
        decoration: const BoxDecoration(
          color: blackColor,
        ),
        padding: EdgeInsets.fromLTRB(0.0, widget.bottomSafeArea, 0.0, 0.0),
      ),
      tag: "MainScreenBottomBarHero",
    );

  }

}
import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';

class MainScreenTopBarContainer extends StatefulWidget {
  const MainScreenTopBarContainer({Key? key, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  @override
  MainScreenTopBarContainerState createState() => MainScreenTopBarContainerState();

}

class MainScreenTopBarContainerState extends State<MainScreenTopBarContainer> with RouteAware {

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
        padding: EdgeInsets.fromLTRB(0.0, widget.topSafeArea, 0.0, 0.0),
      ),
      tag: "MainScreenTopBarHero",
    );

  }

}
import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';

class MainScreenMediaButtonContainer extends StatefulWidget {
  const MainScreenMediaButtonContainer({Key? key, required this.buttonAction, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final VoidCallback buttonAction;

  @override
  MainScreenMediaButtonContainerState createState() => MainScreenMediaButtonContainerState();

}

class MainScreenMediaButtonContainerState extends State<MainScreenMediaButtonContainer> with RouteAware {

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
      child: SizedBox(
        child: ElevatedButton(
          child: Container(
            child: Stack(
              children: const [
                Icon(
                  photoIconData,
                  size: 18.0,
                  color: whiteColor,
                ),
                Positioned(
                  child: Icon(
                    addIconData,
                    size: 12.0,
                    color: blackColor,
                  ),
                  bottom: 3.0,
                  right: 3.0,
                  width: 10.0,
                  height: 10.0,
                ),
                Positioned(
                  child: Icon(
                    addIconData,
                    size: 10.0,
                    color: lightBlueColor,
                  ),
                  bottom: 0.0,
                  right: 0.0,
                  width: 10.0,
                  height: 10.0,
                ),
              ],
              alignment: Alignment.center,
            ),
            width: 30.0,
            height: 30.0,
            margin: const EdgeInsets.only(left: 35.0),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: lightBlueColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0))),
            elevation: 0.0,

            padding: const EdgeInsets.all(0.0),
          ),
          onPressed: () => widget.buttonAction(),
        ),
        width: (widget.pageWidth / 2.0),
        height: 70.0,
      ),
      tag: "MainScreenMediaButtonHero",
    );

  }

}
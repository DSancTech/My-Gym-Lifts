import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:my_gym_lifts/components/icon_gradient_mask.dart';

class MainIcon extends StatefulWidget {
  const MainIcon({Key? key, required this.mainButtonAction, required this.useIcon, required this.hasColor, required this.useHero, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final bool useHero;
  final bool hasColor;
  final bool useIcon;

  final VoidCallback mainButtonAction;

  @override
  MainIconState createState() => MainIconState();

}

class MainIconState extends State<MainIcon> with TickerProviderStateMixin {

  /// Init State
  @override
  void initState() {
    super.initState();

  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Inner Container
    var innerContainer = Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: blackColor,
      ),
      child: Stack(
        children: [
          Positioned(
            child: ElevatedButton(
              child: Container(color: Colors.transparent),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: lightBlueColor,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                elevation: 0.0,
                padding: const EdgeInsets.all(0.0),
              ),
              onPressed: () => widget.mainButtonAction(),
            ),
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
          ),
          Positioned(
            child: IgnorePointer(
              child: LayoutBuilder(builder: (context, constraint) {
                return widget.useIcon ? IconGradientMask(
                  child: Icon(
                    mainIconData,
                    size: constraint.biggest.width - 8.0,
                    color: Colors.white,
                  ),
                  firstColor: widget.hasColor ? darkBlueColor : whiteColor,
                  secondColor: widget.hasColor ? lightBlueColor : whiteColor,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ) : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/main_icon.png'),
                    ),
                  ),
                  width: constraint.biggest.width,
                  height: constraint.biggest.height,
                );
              }),
              ignoring: true,
            ),
            left: 8.0,
            right: 8.0,
            top: 0.0,
            bottom: 0.0,
          ),
        ],
      ),
    );

    /// Main Icon
    return widget.useHero ? Hero(
      child: innerContainer,
      tag: "MainIconHero",
    ) : innerContainer;

  }
}
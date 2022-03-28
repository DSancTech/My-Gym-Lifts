import 'package:flutter/material.dart';

class IconGradientMask extends StatelessWidget {const IconGradientMask({Key? key, this.child, required this.firstColor, required this.secondColor, required this.begin, required this.end}) : super(key: key);

  final Widget? child;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  final Color firstColor;
  final Color secondColor;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: begin,
        end: end,
        stops: const [0.25, 0.75],
        colors: [firstColor, secondColor],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }

}
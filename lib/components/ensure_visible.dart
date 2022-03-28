import 'package:flutter/widgets.dart';

class EnsureVisibleWhenFocused extends StatefulWidget {

  const EnsureVisibleWhenFocused({
    Key? key,
    required this.child,
    required this.focusNode,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(milliseconds: 100),
  }) : super(key: key);


  final FocusNode focusNode;
  final Widget child;
  final Curve curve;
  final Duration duration;

  @override
  EnsureVisibleWhenFocusedState createState() => EnsureVisibleWhenFocusedState();

}

class EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  Future<Null> _ensureVisible() async {
    // Possibly needs a delay or position not called
    await Future.delayed(const Duration(milliseconds: 00));

    if (!widget.focusNode.hasFocus) {
      return;
    }

  }

  @override
  Widget build(BuildContext context) => widget.child;

}
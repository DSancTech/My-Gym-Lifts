import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:after_layout/after_layout.dart';
import 'package:my_gym_lifts/components/ensure_visible.dart';

class MainScreenSearchBarContainer extends StatefulWidget {
  const MainScreenSearchBarContainer({Key? key, required this.searchByVoice, required this.searchTextFieldAction, required this.searchTextFieldClear, required this.searchTextFieldDidChange, required this.searchTextFieldController, required this.searchTextFieldFocusNode, required this.searchTextFieldString, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final TextEditingController searchTextFieldController;
  final FocusNode searchTextFieldFocusNode;
  final String searchTextFieldString;
  final Function(String) searchTextFieldDidChange;
  final VoidCallback searchTextFieldClear;
  final VoidCallback searchTextFieldAction;
  final VoidCallback searchByVoice;

  @override
  MainScreenSearchBarContainerState createState() => MainScreenSearchBarContainerState();

}

class MainScreenSearchBarContainerState extends State<MainScreenSearchBarContainer> with RouteAware, AfterLayoutMixin<MainScreenSearchBarContainer>, TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MainScreenSearchBarContainer> {

  /// Keep Page Alive
  @override
  bool get wantKeepAlive => true;

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

  }

  /// Build Widget
  @override
  Widget build(BuildContext context) {

    /// Search Icon Container
    var searchIconContainer = Container(
      child: const Icon(
        searchIconData,
        size: 14.0,
        color: whiteColor,
      ),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Search Text Field Container
    var searchTextFieldContainer = Expanded(
      child: SizedBox(
        child: Material(
          color: Colors.transparent,
          child: EnsureVisibleWhenFocused(
            focusNode: widget.searchTextFieldFocusNode,
            child: TextField(
              focusNode: widget.searchTextFieldFocusNode,
              controller: widget.searchTextFieldController,
              onChanged: (textFieldString) => widget.searchTextFieldDidChange(textFieldString),
              onSubmitted: (value) => widget.searchTextFieldAction(),
              cursorColor: lightBlueColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 3.0),
                hintText: r"bench press, 2 reps, etc.",
                hintStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontWeight: lightWeight,
                  fontSize: regularFontSize,
                  decoration: TextDecoration.none,
                  color: whiteColor.withOpacity(0.3),
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontFamily: fontFamily,
                fontWeight: regularWeight,
                fontSize: regularFontSize,
                decoration: TextDecoration.none,
                color: whiteColor,
              ),
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.text,
              obscureText: false,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      ),
    );

    /// Clear Button Container
    var clearButtonContainer = SizedBox(
      child: AnimatedOpacity(
        child: ElevatedButton(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor.withOpacity(0.2)
            ),
            child: Icon(
              Icons.clear_rounded,
              size: 10.0,
              color: whiteColor.withOpacity(0.6),
            ),
            width: 16.0,
            height: 16.0,
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: whiteColor,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 0.0,
            padding: const EdgeInsets.all(0.0),
          ),
          onPressed: () => widget.searchTextFieldClear(),
        ),
        opacity: widget.searchTextFieldString.isEmpty ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
      ),
      height: 45.0,
      width: 30.0,
    );

    /// Mic Button Container
    var micButtonContainer = SizedBox(
      child: ElevatedButton(
        child: const Icon(
          micIconData,
          size: 16.0,
          color: whiteColor,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: lightBlueColor,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
          elevation: 0.0,
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () => widget.searchByVoice(),
      ),
      height: 45.0,
      width: 50.0,
    );

    /// Main Container
    return Hero(
      child: Container(
        decoration: const BoxDecoration(
          color: lightGrayColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: <Widget>[
            searchIconContainer,
            searchTextFieldContainer,
            clearButtonContainer,
            micButtonContainer,
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
        ),
      ),
      tag: "MainScreenSearchBarHero",
    );

  }

}
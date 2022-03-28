import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_gym_lifts/components/shared.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_gym_lifts/components/ensure_visible.dart';

class VideoDataEditingContainer extends StatefulWidget {
  const VideoDataEditingContainer({Key? key, required this.percentage, required this.percentageChanged, required this.percentageTextFieldController, required this.percentageTextFieldFocusNode, required this.keyboardOpen, required this.keyboardHeight, required this.deleteButtonAction, required this.newVideo, required this.cancelButtonAction, required this.nameTextFieldController, required this.nameTextFieldAction, required this.lbsTextFieldController, required this.kgTextFieldController, required this.weightTextFieldsAction, required this.repsTextFieldController, required this.repsTextFieldAction, required this.rpeTextFieldController, required this.rirTextFieldController, required this.difficultyTextFieldsAction, required this.descriptionTextFieldController, required this.descriptionTextFieldAction, required this.nameTextFieldFocusNode, required this.lbsTextFieldFocusNode, required this.kgTextFieldFocusNode, required this.repsTextFieldFocusNode, required this.rpeTextFieldFocusNode, required this.rirTextFieldFocusNode, required this.descriptionTextFieldFocusNode, required this.nameChanged, required this.prChanged, required this.lbsChanged, required this.kgChanged, required this.repsChanged, required this.rpeChanged, required this.rirChanged, required this.descriptionChanged, required this.name, required this.pr, required this.lbs, required this.kg, required this.reps, required this.rpe, required this.rir, required this.description, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;
  final bool keyboardOpen;
  final double keyboardHeight;

  final bool newVideo;

  final String name;
  final Function(String) nameChanged;
  final FocusNode nameTextFieldFocusNode;
  final TextEditingController nameTextFieldController;
  final VoidCallback nameTextFieldAction;
  final bool pr;
  final VoidCallback prChanged;
  final double lbs;
  final FocusNode lbsTextFieldFocusNode;
  final TextEditingController lbsTextFieldController;
  final Function(double) lbsChanged;
  final double kg;
  final FocusNode kgTextFieldFocusNode;
  final TextEditingController kgTextFieldController;
  final Function(double) kgChanged;
  final VoidCallback weightTextFieldsAction;
  final int reps;
  final Function(int) repsChanged;
  final FocusNode repsTextFieldFocusNode;
  final TextEditingController repsTextFieldController;
  final VoidCallback repsTextFieldAction;
  final int rpe;
  final FocusNode rpeTextFieldFocusNode;
  final TextEditingController rpeTextFieldController;
  final Function(int) rpeChanged;
  final int rir;
  final FocusNode rirTextFieldFocusNode;
  final TextEditingController rirTextFieldController;
  final Function(int) rirChanged;
  final double percentage;
  final FocusNode percentageTextFieldFocusNode;
  final TextEditingController percentageTextFieldController;
  final Function(double) percentageChanged;
  final VoidCallback difficultyTextFieldsAction;
  final String description;
  final Function(String) descriptionChanged;
  final FocusNode descriptionTextFieldFocusNode;
  final TextEditingController descriptionTextFieldController;
  final VoidCallback descriptionTextFieldAction;

  final VoidCallback cancelButtonAction;
  final VoidCallback deleteButtonAction;

  @override
  VideoDataEditingContainerState createState() => VideoDataEditingContainerState();

}

class VideoDataEditingContainerState extends State<VideoDataEditingContainer> with RouteAware {

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
    
    /// Sub Text Style
    var subTextStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: extraSmallFontSize,
      fontWeight: semiBoldWeight,
      color: whiteColor,
      decoration: TextDecoration.none,
    );

    /// Main Text Style
    var mainTextStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: regularFontSize,
      fontWeight: regularWeight,
      color: whiteColor,
      decoration: TextDecoration.none,
    );

    /// Hint Text Style
    var hintTextStyle = TextStyle(
      fontFamily: fontFamily,
      fontSize: regularFontSize,
      fontWeight: lightWeight,
      color: whiteColor.withOpacity(0.3),
      decoration: TextDecoration.none,
    );

    /// Text Field Container Decoration
    var textFieldContainerDecoration = const BoxDecoration(
      color: darkGrayColor,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    );

    /// Top Buttons Container
    var topButtonsContainer = Container(
      child: Row(
        children: [
          SizedBox(
            child: ElevatedButton(
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: smallFontSize,
                  fontWeight: boldWeight,
                  decoration: TextDecoration.none,
                  color: whiteColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: lightBlueColor,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                elevation: 0.0,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              ),
              onPressed: () => widget.cancelButtonAction(),
            ),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            child: ElevatedButton(
              child: const Text(
                'Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: smallFontSize,
                  fontWeight: boldWeight,
                  decoration: TextDecoration.none,
                  color: darkRedColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: lightBlueColor,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                elevation: 0.0,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              ),
              onPressed: () => widget.deleteButtonAction(),
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
    );

    /// PR Button Container
    var prButtonContainer = AnimatedContainer(
      decoration: BoxDecoration(
        color: widget.pr ? yellowColor : whiteColor.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: const Center(
        child: Text(
          'PR',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: extraSmallFontSize,
            fontWeight: extraBoldWeight,
            color: darkGrayColor,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      padding: const EdgeInsets.all(4.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutExpo,
      width: 40.0,
      height: 30.0,
    );

    /// Name Container
    var nameContainer = Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  'Exercise',
                  style: subTextStyle,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  r'* Required',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: extraSmallFontSize,
                    fontWeight: lightWeight,
                    color: whiteColor.withOpacity(0.7),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          Container(
            decoration: textFieldContainerDecoration,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: EnsureVisibleWhenFocused(
                      focusNode: widget.nameTextFieldFocusNode,
                      child: TextField(
                        focusNode: widget.nameTextFieldFocusNode,
                        controller: widget.nameTextFieldController,
                        onChanged: (textFieldString) => widget.nameChanged(textFieldString),
                        onSubmitted: (value) => widget.nameTextFieldAction(),
                        cursorColor: lightBlueColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          hintText: r"Bench Press",
                          hintStyle: hintTextStyle,
                          border: InputBorder.none,
                        ),
                        style: mainTextStyle,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    child: prButtonContainer,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: blackColor,
                      shadowColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                      elevation: 0.0,
                      padding: const EdgeInsets.all(0.0),
                    ),
                    onPressed: () => widget.prChanged(),
                  ),
                  width: 55.0,
                  height: 50.0,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            margin: const EdgeInsets.only(top: 8.0),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      width: widget.pageWidth,
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Weight Container
    var weightContainer = Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Weight',
              style: subTextStyle,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: textFieldContainerDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: EnsureVisibleWhenFocused(
                              focusNode: widget.lbsTextFieldFocusNode,
                              child: TextField(
                                focusNode: widget.lbsTextFieldFocusNode,
                                controller: widget.lbsTextFieldController,
                                onChanged: (textFieldString) => widget.lbsChanged(double.parse(textFieldString)),
                                onSubmitted: (value) => widget.weightTextFieldsAction(),
                                cursorColor: lightBlueColor,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  hintText: r"0",
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                style: mainTextStyle,
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'lbs',
                          style: subTextStyle,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.only(top: 4.0),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: textFieldContainerDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: EnsureVisibleWhenFocused(
                              focusNode: widget.kgTextFieldFocusNode,
                              child: TextField(
                                focusNode: widget.kgTextFieldFocusNode,
                                controller: widget.kgTextFieldController,
                                onChanged: (textFieldString) => widget.kgChanged(double.parse(textFieldString)),
                                onSubmitted: (value) => widget.weightTextFieldsAction(),
                                cursorColor: lightBlueColor,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  hintText: r"0",
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                style: mainTextStyle,
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'kg',
                          style: subTextStyle,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.only(top: 8.0),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
            ),
            width: widget.pageWidth,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Reps Container
    var repsContainer = Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Reps',
              style: subTextStyle,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          Container(
            decoration: textFieldContainerDecoration,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: EnsureVisibleWhenFocused(
                      focusNode: widget.repsTextFieldFocusNode,
                      child: TextField(
                        focusNode: widget.repsTextFieldFocusNode,
                        controller: widget.repsTextFieldController,
                        onChanged: (textFieldString) => widget.repsChanged(int.parse(textFieldString)),
                        onSubmitted: (value) => widget.repsTextFieldAction(),
                        cursorColor: lightBlueColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          hintText: r"0",
                          hintStyle: hintTextStyle,
                          border: InputBorder.none,
                        ),
                        style: mainTextStyle,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Reps',
                  style: subTextStyle,
                ),
                const SizedBox(width: 16.0),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            width: widget.pageWidth,
            margin: const EdgeInsets.only(top: 8.0),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Difficulty Container
    var difficultyContainer = Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Difficulty',
              style: subTextStyle,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: textFieldContainerDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: EnsureVisibleWhenFocused(
                              focusNode: widget.rpeTextFieldFocusNode,
                              child: TextField(
                                focusNode: widget.rpeTextFieldFocusNode,
                                controller: widget.rpeTextFieldController,
                                onChanged: (textFieldString) => widget.rpeChanged(int.parse(textFieldString)),
                                onSubmitted: (value) => widget.difficultyTextFieldsAction(),
                                cursorColor: lightBlueColor,
                                inputFormatters: [
                                  RpeRirTextInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  hintText: r"0",
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                style: mainTextStyle,
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'RPE',
                          style: subTextStyle,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.only(top: 8.0),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: textFieldContainerDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: EnsureVisibleWhenFocused(
                              focusNode: widget.rirTextFieldFocusNode,
                              child: TextField(
                                focusNode: widget.rirTextFieldFocusNode,
                                controller: widget.rirTextFieldController,
                                onChanged: (textFieldString) => widget.rirChanged(int.parse(textFieldString)),
                                onSubmitted: (value) => widget.difficultyTextFieldsAction(),
                                cursorColor: lightBlueColor,
                                inputFormatters: [
                                  RpeRirTextInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  hintText: r"10",
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                style: mainTextStyle,
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'RIR',
                          style: subTextStyle,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.only(top: 8.0),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: textFieldContainerDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: EnsureVisibleWhenFocused(
                              focusNode: widget.percentageTextFieldFocusNode,
                              child: TextField(
                                focusNode: widget.percentageTextFieldFocusNode,
                                controller: widget.percentageTextFieldController,
                                onChanged: (textFieldString) => widget.percentageChanged(double.parse(textFieldString)),
                                onSubmitted: (value) => widget.difficultyTextFieldsAction(),
                                cursorColor: lightBlueColor,
                                inputFormatters: [
                                  PercentageTextInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                  hintText: r"90.0",
                                  hintStyle: hintTextStyle,
                                  border: InputBorder.none,
                                ),
                                style: mainTextStyle,
                                keyboardAppearance: Brightness.dark,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          r'%',
                          style: subTextStyle,
                        ),
                        const SizedBox(width: 16.0),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.only(top: 8.0),
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
            ),
            width: widget.pageWidth,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Notes Container
    var notesContainer = Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Notes',
              style: subTextStyle,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          Container(
            decoration: textFieldContainerDecoration,
            child: EnsureVisibleWhenFocused(
              focusNode: widget.descriptionTextFieldFocusNode,
              child: TextField(
                focusNode: widget.descriptionTextFieldFocusNode,
                controller: widget.descriptionTextFieldController,
                onChanged: (textFieldString) => widget.descriptionChanged(textFieldString),
                onSubmitted: (value) => widget.descriptionTextFieldAction(),
                cursorColor: lightBlueColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  hintText: r"Misgrooved, moved well, etc...",
                  hintStyle: hintTextStyle,
                  border: InputBorder.none,
                ),
                style: mainTextStyle,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.text,
                obscureText: false,
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
              ),
            ),
            margin: const EdgeInsets.only(top: 8.0),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    );

    /// Main Container
    return SizedBox(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, widget.newVideo ? 24.0 : 8.0, 0.0, (widget.bottomSafeArea + widget.keyboardHeight+ (widget.keyboardOpen ? 76.0 : 24.0))),
        children: [
          widget.newVideo ? const SizedBox() : topButtonsContainer,
          nameContainer,
          const SizedBox(height: 16.0),
          weightContainer,
          const SizedBox(height: 16.0),
          repsContainer,
          const SizedBox(height: 16.0),
          difficultyContainer,
          const SizedBox(height: 16.0),
          notesContainer,
        ],
      ),
    );

  }

}

/// RPE/RIR Text Input Formatter
class RpeRirTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if (newValue.text == '') {
      return const TextEditingValue();
    }
    else if(int.parse(newValue.text) < 1) {
      return const TextEditingValue().copyWith(text: '1');
    }

    return int.parse(newValue.text) > 10 ? const TextEditingValue().copyWith(text: '10') : newValue;
  }
}

/// Percentage Text Input Formatter
class PercentageTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,TextEditingValue newValue,) {
    if (newValue.text == '') {
      return const TextEditingValue();
    }
    else if(double.parse(newValue.text) < 0.0) {
      return const TextEditingValue().copyWith(text: '0.0');
    }

    return int.parse(newValue.text) > 100.0 ? const TextEditingValue().copyWith(text: '100.0') : newValue;
  }
}
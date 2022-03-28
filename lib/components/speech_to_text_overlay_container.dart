import 'package:flutter/material.dart';
import 'package:my_gym_lifts/components/shared.dart';
//import 'package:speech_to_text/speech_to_text.dart';
//import 'package:speech_to_text/speech_recognition_result.dart';
//import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';

class SpeechToTextOverlayContainer extends StatefulWidget {
  const SpeechToTextOverlayContainer({Key? key, required this.recognizedText, required this.cancelAction, required this.acceptAction, required this.pageHeight, required this.pageWidth, required this.topSafeArea, required this.bottomSafeArea}) : super(key: key);

  final double pageWidth;
  final double pageHeight;
  final double topSafeArea;
  final double bottomSafeArea;

  final String recognizedText;
  final VoidCallback cancelAction;
  final VoidCallback acceptAction;

  @override
  SpeechToTextOverlayContainerState createState() => SpeechToTextOverlayContainerState();

}

class SpeechToTextOverlayContainerState extends State<SpeechToTextOverlayContainer> with RouteAware {

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

    /// Wave Container
    var waveContainer = SizedBox(
      child: WaveWidget(
        backgroundColor: Colors.transparent,
        config: CustomConfig(
          gradients: [
            [lightBlueColor.withOpacity(0.6), darkBlueColor.withOpacity(0.4)],
            [darkBlueColor.withOpacity(0.6), lightBlueColor.withOpacity(0.4)],
            [lightBlueColor.withOpacity(0.6), darkBlueColor.withOpacity(0.4)],
            [darkBlueColor.withOpacity(0.6), lightBlueColor.withOpacity(0.4)]
          ],
          durations: [35000, 19440, 10800, 6000],
          heightPercentages: [0.15, 0.25, 0.35, 0.45],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        waveAmplitude: 10,
        heightPercentange: 1.0,
        size: const Size(
          double.infinity,
          double.infinity,
        ),
      ),
      width: widget.pageWidth,
      height: 0.0,
    );

    /// Top Container
    var topContainer = Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              child: AutoSizeText(
                widget.recognizedText,
                style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: largeFontSize,
                  fontWeight: boldWeight,
                  color: whiteColor,
                  decoration: TextDecoration.none,
                ),
                minFontSize: regularFontSize,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              margin: const EdgeInsets.only(bottom: 16.0),
            ),
            SizedBox(
              child: Text(
                'Listening...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: regularFontSize,
                  fontWeight: lightWeight,
                  color: whiteColor.withOpacity(0.6),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        padding: EdgeInsets.fromLTRB(24.0, widget.topSafeArea, 24.0, 0.0),
      ),
    );

    /// Bottom Container
    var bottomContainer = Expanded(
      child: Container(
        child: Column(
          children: [
            AnimatedOpacity(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [lightBlueColor, darkBlueColor],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  child: const Text(
                    'Accept',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: regularFontSize,
                      fontWeight: regularWeight,
                      decoration: TextDecoration.none,
                      color: whiteColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: lightBlueColor,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    elevation: 0.0,
                    padding: const EdgeInsets.all(0.0),
                  ),
                  onPressed: widget.recognizedText.isEmpty ? null : () => widget.acceptAction(),
                ),
                height: 45.0,
                width: 140.0,
                margin: const EdgeInsets.only(bottom: 16.0),
              ),
              opacity: widget.recognizedText.isEmpty ? 0.4 : 1.0,
              duration: const Duration(milliseconds: 200),
            ),
            SizedBox(
              child: ElevatedButton(
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: regularFontSize,
                    fontWeight: regularWeight,
                    decoration: TextDecoration.none,
                    color: whiteColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: lightBlueColor,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  elevation: 0.0,
                  padding: const EdgeInsets.all(0.0),
                ),
                onPressed: () => widget.cancelAction(),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, widget.bottomSafeArea),
      ),
    );

    /// Main Container
    return Container(
      color: blackColor.withOpacity(0.7),
      child: Column(
        children: [
          topContainer,
          waveContainer,
          bottomContainer,
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      width: widget.pageWidth,
      height: widget.pageHeight,
    );

  }

}
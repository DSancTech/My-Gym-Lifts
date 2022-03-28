// @dart=2.8
import 'package:flutter/material.dart';
import 'package:statusbarz/statusbarz.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_gym_lifts/components/shared.dart';
import 'package:my_gym_lifts/screens/launch_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Directory appDocsDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) => Container(color: Colors.transparent);

  appDocsDir = await getApplicationDocumentsDirectory();

  initializeDateFormatting().then((_) => runApp(const StatusbarzCapturer(child: App())));
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  AppState createState() => AppState();

}

class AppState extends State<App> {

  /// Global Route Observer
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  /// Video Data
  Map<String, dynamic> videoData = {"data":[]};

  @override
  void initState() {
    super.initState();
    
    checkForFile();
  }

  /// Check For File
  checkForFile() async {
    final File file = File('${appDocsDir.path}/videosData.json');
    if ((await file.exists()) == false) {
      await file.writeAsString(json.encode(videoData));
    }
  }

  @override
  Widget build(BuildContext context) {

    /// Vars
    var platform = Theme.of(context).platform;
    var oniOS = (platform == TargetPlatform.iOS);

    /// Set Preferred Orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// App
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: r"My Gym Lifts",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: darkBlueColor,
        fontFamily: fontFamily,
        backgroundColor: darkGrayColor,
        scaffoldBackgroundColor: darkGrayColor,
      ),
      navigatorObservers: <NavigatorObserver>[routeObserver],
      home: LaunchScreen(
        oniOS: oniOS,
        appDocsDir: appDocsDir,
      ),
    );

  }

}

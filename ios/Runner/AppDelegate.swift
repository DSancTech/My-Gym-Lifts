import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [AVAudioSession.CategoryOptions.mixWithOthers, AVAudioSession.CategoryOptions.defaultToSpeaker, AVAudioSession.CategoryOptions.allowBluetooth])
    }
    catch {
        print("AVAudioSession Error")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}


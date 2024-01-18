import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/util/downloader_util.dart';

class AppSetting {
  Future initApp() async {
    return Future.wait([
      //init locale language
      EasyLocalization.ensureInitialized(),

      //init downloader
      FlutterDownloader.initialize(debug: true, ignoreSsl: true).whenComplete(() {
        FlutterDownloader.registerCallback(downloadCallback);
      }),
    ]);
  }
}

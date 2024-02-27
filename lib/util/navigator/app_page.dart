import 'package:flutter/material.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/feature/setting/setting_page.dart';
import 'package:mp3_convert/feature/tracking_speed/page/speed_page.dart';
import 'package:mp3_convert/widget/button/go_button.dart';

class GetHelpAndFeedbackPage extends AppPage {
  GetHelpAndFeedbackPage() : super('/help-and-feedback');

  @override
  Widget? getPage(Object? arguments) {
    return const HelpAndFeedbackPage();
  }
}

class GetSettingPage extends AppPage {
  GetSettingPage() : super('/setting');

  @override
  Widget? getPage(Object? arguments) {
    return const SettingPage();
  }
}

class GetHomePage extends AppPage {
  GetHomePage() : super('/home');

  @override
  Widget? getPage(Object? arguments) {
    return const SpeedPage();
  }
}

sealed class AppPage {
  final String path;

  AppPage(this.path);

  Widget? getPage(Object? arguments);
}

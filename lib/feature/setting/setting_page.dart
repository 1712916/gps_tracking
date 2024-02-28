import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gps_speed/base_presentation/page/base_page.dart';
import 'package:gps_speed/base_presentation/view/view.dart';
import 'package:gps_speed/resource/string.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BasePageState<SettingPage> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: LText(SettingLocalization.setting),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Loca(),
        ],
      ),
    );
  }
}

class Loca extends StatelessWidget {
  const Loca({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LText(
              SettingLocalization.language,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...context.supportedLocales.map(
              (l) => GestureDetector(
                onTap: () {
                  context.setLocale(l);
                },
                child: Row(
                  children: [
                    Radio(
                      value: l.languageCode,
                      groupValue: context.locale.languageCode,
                      onChanged: (_) {
                        context.setLocale(l);
                      },
                    ),
                    LText("${l.languageCode}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

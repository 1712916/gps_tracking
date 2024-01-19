import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/view/base_view.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/widget/convert_status_widget.dart';
import 'package:mp3_convert/feature/home/widget/file_type_widget.dart';
import 'package:mp3_convert/util/reduce_text.dart';
import 'package:mp3_convert/widget/button/loading_button.dart';

class AppFileCard extends StatefulWidget {
  const AppFileCard({
    super.key,
    required this.file,
    required this.onSelectDestinationType,
    required this.onConvert,
    required this.onRetry,
  });

  final ConfigConvertFile file;
  final ValueChanged<String> onSelectDestinationType;
  final VoidCallback onConvert;
  final VoidCallback onRetry;

  @override
  State<AppFileCard> createState() => _AppFileCardState();
}

class _AppFileCardState extends BaseStatefulWidgetState<AppFileCard> {
  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: const Offset(0, -2), blurRadius: 4.0, color: Colors.black.withOpacity(0.04)),
          BoxShadow(offset: const Offset(0, 4), blurRadius: 8.0, color: Colors.black.withOpacity(0.12)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reduceText(file.name),
                  style: textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 12),
              Row(
                children: [
                  LoadingButton(
                    child: Text(file.destinationType ?? "Chọn"),
                    isError: file is UnValidConfigConvertFile,
                    onTap: () async {
                      final listMediaType = await context.read<ConvertCubit>().getMappingType(file.type);
                      ListMediaTypeWidget(
                        typeList: listMediaType ?? ListMediaType(types: []),
                        initList: file.destinationType != null ? [MediaType(name: file.destinationType!)] : null,
                      ).showBottomSheet(context).then((destinationType) {
                        if (destinationType != null) {
                          if (destinationType.isNotEmpty) {
                            widget.onSelectDestinationType(destinationType.first.name);
                          }
                        }
                      });
                    },
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                ],
              )
            ],
          ),
          if (file is ConvertErrorFile)
            Column(
              children: [
                const Divider(),
                ConvertErrorWidget(
                  onRetry: widget.onRetry,
                ),
              ],
            )
          else if (file.destinationType != null)
            if (file is ConvertStatusFile)
              const SizedBox()
            else
              Column(
                children: [
                  const Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: widget.onConvert,
                      child: Center(
                        child: Text(
                          "Convert",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
          if (file is ConvertStatusFile)
            Column(
              children: [
                const Divider(),
                ConvertStatusWidget(
                  convertFile: file,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

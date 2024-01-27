import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/widget/file_type_widget.dart';
import 'package:mp3_convert/feature/cutter/cubit/cutter_cubit.dart';
import 'package:mp3_convert/feature/cutter/load_audio_data.dart';
import 'package:mp3_convert/feature/cutter/waveform/get_wave_form.dart';
import 'package:mp3_convert/feature/cutter/widget/audio_cutter_widget.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:mp3_convert/widget/empty_picker_widget.dart';
import 'dart:math' as math;

class AudioCutterPage extends StatefulWidget {
  const AudioCutterPage({Key? key}) : super(key: key);

  @override
  _AudioCutterPageState createState() => _AudioCutterPageState();
}

class _AudioCutterPageState extends SingleProviderBasePageState<AudioCutterPage, CutterCubit> {
  _AudioCutterPageState() : super(cubit: CutterCubit());

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: super.build(context));
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocSelector<CutterCubit, CutterState, String?>(
          selector: (state) => state.file?.name,
          builder: (context, name) {
            return Text(name ?? '');
          }),
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<CutterCubit, CutterState>(
      builder: (context, state) {
        final file = state.file;
        if (file != null) {
          return _AudioPage(file: file);
        }
        return EmptyPickerWidget(
          canPickMultipleFile: false,
          onGetFiles: (files) {
            cubit.setFile(files.first);
          },
        );
      },
    );
  }
}

class _AudioPage extends StatefulWidget {
  const _AudioPage({super.key, required this.file});
  final AppFile file;

  @override
  State<_AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<_AudioPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          CutterAudioWidget(path: widget.file.path),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xfffff25d17),
              ),
              onPressed: () {},
              child: Center(child: Text("Start Cut".hardCode)),
            ),
          ),
          ColumnStart(
            children: [
              const SizedBox(height: 20),
              BlocSelector<CutterCubit, CutterState, bool>(
                selector: (state) => state.isRemoveSelection ?? false,
                builder: (context, state) {
                  return Row(
                    children: [
                      Checkbox(
                        value: state,
                        onChanged: (value) {
                          context.read<CutterCubit>().setRemoveSelection(value ?? false);
                        },
                      ),
                      Text("Remove selection".hardCode),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Convert Type".hardCode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              BlocBuilder<CutterCubit, CutterState>(
                builder: (context, state) {
                  final types = state.listMediaType?.types;
                  if (types == null) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ...types.map(
                          (type) => MediaTypeChip(
                            type: type,
                            isSelected: type.name == state.destinationType,
                            onChanged: (value) {
                              context.read<CutterCubit>().setConvertType(type);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

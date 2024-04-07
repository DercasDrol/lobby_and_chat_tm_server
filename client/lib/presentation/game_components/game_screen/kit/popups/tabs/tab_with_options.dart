import 'package:flutter/material.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_option_info.dart';

class TabWithOptions extends StatelessWidget {
  final List<PresentationOptionInfo> optionsInfo;
  final ValueNotifier<int?> selectedOption;

  TabWithOptions({
    required this.selectedOption,
    required this.optionsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListenableBuilder(
        listenable: selectedOption,
        builder: (context, widget) => Column(
          mainAxisSize: MainAxisSize.min,
          children: optionsInfo.indexed.map(
            (optionInfo) {
              logger.d(optionInfo.$2.title);
              return RadioListTile<int>(
                title: Text(
                  optionInfo.$2.title,
                ),
                value: optionInfo.$1,
                groupValue: selectedOption.value,
                onChanged: (int? value) {
                  selectedOption.value = value;
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

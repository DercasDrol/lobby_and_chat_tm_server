import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mars_flutter/common/log.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/expansion_type.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/chat_and_lobby/option_miniature_model.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';

import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';
import 'package:mars_flutter/presentation/game_components/lobby_screen/kit/common/options_miniatures_row.dart';

class ExpansionsView extends StatelessWidget {
  final List<ExpansionType> expansions;
  final List<ExpansionType> selectedExpansions;
  final void Function(List<ExpansionType>)? onSelectedExpansionsChanged;

  const ExpansionsView({
    super.key,
    required this.expansions,
    required this.selectedExpansions,
    required this.onSelectedExpansionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    logger.d(selectedExpansions);
    List<ExpansionType> _selectedExpansions = [];
    _selectedExpansions.addAll(selectedExpansions);

    final createRow = (ExpansionType expansion) {
      return DropdownItem(
        height: 26.0,
        value: expansion,
        //disable default onTap to avoid closing menu when selecting an item
        enabled: false,
        child: StatefulBuilder(
          builder: (context, menuSetState) {
            final isSelected = _selectedExpansions.contains(expansion);
            final onTap = () {
              isSelected
                  ? _selectedExpansions.remove(expansion)
                  : _selectedExpansions.add(expansion);
              if (!isSelected)
                _selectedExpansions.sort((a, b) =>
                    expansions.indexOf(a).compareTo(expansions.indexOf(b)));
              //This rebuilds the dropdownMenu Widget to update the check mark
              menuSetState(() {});
            };
            return TapRegion(
              onTapInside: (event) => onTap(),
              child: Row(
                children: [
                  isSelected
                      ? const Icon(Icons.check_box_outlined)
                      : const Icon(Icons.check_box_outline_blank),
                  const SizedBox(width: 12),
                  GameOptionView(
                    images: [expansion.typeImage],
                    lablePart1: expansion.name,
                    descriptionUrl: expansion.descriptionUrl,
                    type: GameOptionType.SIMPLE,
                  ),
                ],
              ),
            );
          },
        ),
      );
    };
    final createStaticRow = (maxWidth) {
      final createRow = (e) => OptionMiniatureModel.fromExpansionType(
            e,
            _selectedExpansions.contains(e),
          );
      final firstRowExpansionsCount = maxWidth ~/ 26.0;
      final firstRowExpansions = expansions
          .take(
            firstRowExpansionsCount > expansions.length
                ? expansions.length
                : firstRowExpansionsCount,
          )
          .toList();
      return Column(children: [
        OptionMiniaturesRow(
          options: firstRowExpansions.map(createRow).toList(),
        ),
        if (expansions.length > firstRowExpansionsCount)
          OptionMiniaturesRow(
            options: expansions
                .skip(firstRowExpansionsCount)
                .map(createRow)
                .toList(),
          ),
      ]);
    };
    final dropdown = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          DropdownButtonHideUnderline(
        child: DropdownButton2<ExpansionType>(
          barrierColor: Colors.black.withOpacity(0.3),
          isExpanded: false,
          iconStyleData: IconStyleData(
            icon: Icon(Icons.arrow_drop_down),
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.white,
          ),
          hint: Center(
              child: Text(
            'Select Expansions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          )),
          items: expansions.map(createRow).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          valueListenable: ValueNotifier(
              _selectedExpansions.isEmpty ? null : _selectedExpansions.last),
          onChanged: (value) {},
          onMenuStateChange: (isMenuOpen) {
            if (!isMenuOpen && onSelectedExpansionsChanged != null) {
              onSelectedExpansionsChanged!(_selectedExpansions);
            }
          },
          selectedItemBuilder: (context) {
            final row = createStaticRow(constraints.maxWidth);
            return expansions.map((__) => row).toList();
          },

          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );

    return Column(children: [
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      Text('Expansions', style: GAME_OPTIONS_CONSTANTS.blockTitleStyle),
      SizedBox(height: GAME_OPTIONS_CONSTANTS.spaceBetweenOptions),
      GameOptionContainer(
          padding:
              EdgeInsets.all(GAME_OPTIONS_CONSTANTS.internalOptionsPadding),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Container(),
            onSelectedExpansionsChanged != null
                ? dropdown
                : LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) =>
                            createStaticRow(constraints.maxWidth),
                  ),
          ]))
    ]);
  }
}

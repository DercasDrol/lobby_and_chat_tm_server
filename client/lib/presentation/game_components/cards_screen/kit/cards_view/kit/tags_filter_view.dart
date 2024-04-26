import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/chip_box.dart';
import 'package:mars_flutter/presentation/game_components/cards_screen/kit/cards_view/kit/invert_button.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class TagsFilterView extends StatelessWidget {
  final ValueNotifier<List<Tag>> selectedTagsN;
  const TagsFilterView({super.key, required this.selectedTagsN});

  @override
  Widget build(BuildContext context) {
    final tags = Tag.values;
    return Wrap(
      children: [
        InvertButton<Tag>(
          selected: selectedTagsN,
          all: tags,
          onInverted: (inverted) {
            selectedTagsN.value = inverted;
          },
        ),
        ...tags
            .map((tag) => ValueListenableBuilder(
                  valueListenable: selectedTagsN,
                  builder: (context, selectedTags, child) {
                    return ChipBox(
                        labelSymbolCount: 0,
                        useImage: true,
                        child: GameOptionView(
                          useBigberSize: true,
                          image: tag.toImagePath(),
                          type: GameOptionType.TOGGLE_BUTTON,
                          isSelected: selectedTags.contains(tag),
                          onDropdownOptionChangedOrOptionToggled: (_) {
                            if (!selectedTags.contains(tag)) {
                              selectedTagsN.value = [...selectedTags, tag];
                            } else {
                              selectedTagsN.value =
                                  selectedTags.where((t) => t != tag).toList();
                            }
                          },
                        ));
                  },
                ))
            .toList(),
      ],
    );
  }
}

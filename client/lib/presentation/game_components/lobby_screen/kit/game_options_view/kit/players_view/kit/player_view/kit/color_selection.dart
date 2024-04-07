import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game/NewGameConfig.dart';

class ColorSelection extends StatelessWidget {
  final NewPlayerModel player;
  final List<PlayerColor> availablePlayerColors;
  final void Function(NewPlayerModel, bool)? onAnyOptionChanged;

  const ColorSelection({
    super.key,
    required this.player,
    required this.onAnyOptionChanged,
    required this.availablePlayerColors,
  });

  @override
  Widget build(BuildContext context) {
    availablePlayerColors.add(player.color);
    return onAnyOptionChanged != null && availablePlayerColors.length > 1
        ? DropdownButton2<PlayerColor>(
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down),
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              iconSize: 20,
            ),
            alignment: Alignment.center,
            items: availablePlayerColors
                .map(
                  (c) => DropdownItem(
                    child: Center(
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(color: c.toColor(false)),
                      ),
                    ),
                    value: c,
                  ),
                )
                .toList(),
            underline: Container(),
            valueListenable: ValueNotifier(player.color),
            onChanged: (color) {
              if (color != null && onAnyOptionChanged != null)
                onAnyOptionChanged!(player.copyWith(color: color), false);
            },
            buttonStyleData: const ButtonStyleData(
              height: 35,
              width: 39,
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.zero,
            ),
          )
        : Container(
            padding: EdgeInsets.only(right: 20),
            height: 35,
            width: 35,
            child: Center(
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(color: player.color.toColor(false)),
              ),
            ),
          );
  }
}

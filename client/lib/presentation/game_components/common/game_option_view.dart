import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

enum GameOptionType { SIMPLE, TOGGLE_BUTTON, DROPDOWN, BUTTON }

class GameOptionView extends StatelessWidget {
  final List<String>? images;
  final Widget? imageAsWidget;
  final String? lablePart1;
  final String? lablePart2;
  final String? descriptionUrl;
  final Color fontColor;
  final GameOptionType type;
  final List<String>? dropdownOptions;
  final double? dropdownItemWidth;
  final int? dropdownDefaultValueIdx;
  final bool? isSelected;
  final bool? useTwoLines;
  final bool? useBigberSize;
  final void Function((int, String)?)? onDropdownOptionChangedOrOptionToggled;
  static final _defaultSelectedColor = Colors.black;
  static final _defaultNotSelectedColor = Colors.white;

  const GameOptionView({
    super.key,
    this.images,
    this.lablePart1,
    this.lablePart2,
    this.descriptionUrl,
    this.imageAsWidget,
    this.fontColor = Colors.black,
    required this.type,
    this.dropdownOptions,
    this.onDropdownOptionChangedOrOptionToggled,
    this.dropdownDefaultValueIdx,
    this.isSelected,
    this.dropdownItemWidth,
    this.useTwoLines,
    this.useBigberSize,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = useBigberSize ?? false ? 30.0 : 20.0;
    final fontSize = useBigberSize ?? false
        ? GAME_OPTIONS_CONSTANTS.biggerFontSize
        : GAME_OPTIONS_CONSTANTS.fontSize;
    final isInteractive = [
      GameOptionType.TOGGLE_BUTTON,
      GameOptionType.DROPDOWN,
      GameOptionType.BUTTON
    ].contains(type);
    final _fontColor = isInteractive
        ? (isSelected ?? false
            ? _defaultSelectedColor
            : _defaultNotSelectedColor)
        : fontColor;

    (int, String)? _selectedValue = dropdownDefaultValueIdx != null &&
            dropdownOptions != null &&
            dropdownDefaultValueIdx! < dropdownOptions!.length
        ? dropdownOptions!.indexed.elementAt(dropdownDefaultValueIdx!)
        : null;

    final addInkWell = (child) =>
        [GameOptionType.TOGGLE_BUTTON, GameOptionType.BUTTON].contains(type) &&
                onDropdownOptionChangedOrOptionToggled != null
            ? InkWell(
                onTap: onDropdownOptionChangedOrOptionToggled != null
                    ? () => onDropdownOptionChangedOrOptionToggled!(null)
                    : null,
                child: child,
              )
            : child;
    final getDropdown = () => onDropdownOptionChangedOrOptionToggled != null
        ? DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              alignment: Alignment.center,
              barrierColor: Colors.black.withOpacity(0.3),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down),
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.white,
                iconSize: 25,
              ),
              valueListenable: ValueNotifier(_selectedValue?.$2),
              isExpanded: true,
              isDense: true,
              style: TextStyle(color: _fontColor),
              onChanged: (_) => {},
              items: dropdownOptions!.indexed
                  .map<DropdownItem<String>>(((int, String) value) {
                return DropdownItem<String>(
                  value: value.$2,
                  height: 25.0,
                  onTap: () {
                    _selectedValue = value;
                  },
                  child: Center(
                    child: Text(
                      value.$2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onMenuStateChange: (isMenuOpen) {
                if (!isMenuOpen &&
                    onDropdownOptionChangedOrOptionToggled != null &&
                    _selectedValue != null) {
                  onDropdownOptionChangedOrOptionToggled!(_selectedValue);
                }
              },
              selectedItemBuilder: (context) {
                return dropdownOptions!.map(
                  (value) {
                    return Text(
                      value,
                      style: TextStyle(
                        color: GAME_OPTIONS_CONSTANTS
                            .dropdownSelectedItemTextColor,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ).toList();
              },
              buttonStyleData: ButtonStyleData(
                height: 25,
                width: dropdownItemWidth ?? 36.0,
                padding: EdgeInsets.zero,
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.zero,
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 7.0, right: 8.0),
            child: Text(
              _selectedValue?.$2 ?? ' ',
              style: TextStyle(
                color: GAME_OPTIONS_CONSTANTS.dropdownSelectedItemTextColor,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          );
    return addInkWell(Container(
      decoration: BoxDecoration(
        color: isInteractive && (isSelected ?? false) ? Colors.white : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageAsWidget != null)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: imageAsWidget!,
                ),
              ...images
                      ?.map((i) => Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Image.asset(i,
                                width: iconSize, height: iconSize),
                          ))
                      .toList() ??
                  [],
              if (lablePart1 != null)
                Text(
                  lablePart1!,
                  style: TextStyle(
                    color: _fontColor,
                    fontSize: fontSize,
                  ),
                ),
              if (type == GameOptionType.DROPDOWN &&
                  dropdownOptions != null &&
                  !(useTwoLines ?? false))
                getDropdown(),
              if (lablePart2 != null)
                Text(
                  lablePart2!,
                  style: TextStyle(
                    color: _fontColor,
                    fontSize: fontSize,
                  ),
                ),
              if (descriptionUrl != null)
                IconButton(
                  onPressed: () => launchUrl(Uri.parse(descriptionUrl!)),
                  icon: Icon(Icons.info_outline),
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  constraints: BoxConstraints(),
                  color: _fontColor,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          if (type == GameOptionType.DROPDOWN &&
              dropdownOptions != null &&
              (useTwoLines ?? false))
            getDropdown(),
        ],
      ),
    ));
  }
}

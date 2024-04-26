import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/boards/BoardNameType.dart';
import 'package:mars_flutter/presentation/game_components/common/constants.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_container.dart';
import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';

class BoardsView extends StatelessWidget {
  final List<BoardNameType> boards;
  final BoardNameType selectedBoard;
  final void Function(BoardNameType)? onSelectedBoardChanged;
  const BoardsView({
    super.key,
    required this.boards,
    required this.selectedBoard,
    required this.onSelectedBoardChanged,
  });

  @override
  Widget build(BuildContext context) {
    BoardNameType _selectedBoard = selectedBoard;
    final getBoardView = (BoardNameType board, bool useForSelected) {
      return GameOptionView(
        imageAsWidget: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text('⬢', style: TextStyle(color: board.color, fontSize: 20)),
        ),
        lablePart1: useForSelected ? board.shortName : board.name,
        descriptionUrl: board.descriptionUrl,
        fontColor: useForSelected
            ? GAME_OPTIONS_CONSTANTS.dropdownSelectedItemTextColor
            : Colors.black,
        type: GameOptionType.SIMPLE,
      );
    };
    return GameOptionContainer(
      child: onSelectedBoardChanged != null
          ? DropdownButtonHideUnderline(
              child: DropdownButton2<BoardNameType>(
                barrierColor: Colors.black.withOpacity(0.3),
                isExpanded: true,
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                ),
                items: boards.map((board) {
                  return DropdownItem(
                    height: 35.0,
                    value: board,
                    onTap: () {
                      _selectedBoard = board;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _selectedBoard == board
                            ? const Icon(Icons.check)
                            : const SizedBox(width: 12),
                        getBoardView(board, false),
                      ],
                    ),
                  );
                }).toList(),
                //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                valueListenable: ValueNotifier(_selectedBoard),
                onChanged: (value) {},
                onMenuStateChange: (isMenuOpen) {
                  if (!isMenuOpen &&
                      _selectedBoard != selectedBoard &&
                      onSelectedBoardChanged != null) {
                    onSelectedBoardChanged!(_selectedBoard);
                  }
                },
                selectedItemBuilder: (context) {
                  return boards.map(
                    (board) {
                      return Row(
                        children: [
                          Text(' Board: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: GAME_OPTIONS_CONSTANTS.fontSize)),
                          getBoardView(board, true),
                        ],
                      );
                    },
                  ).toList();
                },
                buttonStyleData: const ButtonStyleData(
                  height: 35,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          : Row(
              children: [
                Text(' Board: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: GAME_OPTIONS_CONSTANTS.fontSize)),
                getBoardView(_selectedBoard, true),
              ],
            ),
    );
  }
}

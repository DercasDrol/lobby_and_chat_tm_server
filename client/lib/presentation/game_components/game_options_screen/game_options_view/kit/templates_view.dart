import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';

import 'package:mars_flutter/presentation/game_components/common/game_option_view.dart';
import 'package:mars_flutter/presentation/game_components/common/popups_register.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';

class TemplatesView extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  const TemplatesView({super.key, required this.lobbyCubit});

  @override
  Widget build(BuildContext context) {
    final templates = lobbyCubit.state.gameTemplatesList?.values ?? [];
    final popupCreateName = "showTemplateCreatePopup";
    final popupRemoveName = "showTemplateRemovePopup";
    final templateId = lobbyCubit.state.selectedTemplateId;
    final iconSize = 24.0;

    final createNewTemplateButton = IconButton(
      iconSize: iconSize,
      icon: Icon(Icons.add),
      color: Colors.white,
      tooltip: 'Create new template',
      onPressed: () => PopupsRegistr.registerPopupToShow(popupCreateName, () {
        showDialog(
            barrierColor: Colors.black54,
            context: context,
            builder: (BuildContext context) {
              PopupsRegistr.registerPopupDisposer(
                  popupCreateName, () => Navigator.of(context).pop());
              return Disposer(
                dispose: () {
                  PopupsRegistr.unregisterPopupDisposer(popupCreateName);
                },
                child: LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    String name = "";
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Container(
                        width: constraints.maxWidth * 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter template name',
                              ),
                              onChanged: (val) => name = val,
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            BottomButton(
                              onPressed: () {
                                lobbyCubit.createNewTemplate(name);
                                PopupsRegistr.closePopup(popupCreateName);
                              },
                              text: 'Save',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            });
      }),
    );

    final changeTemplateButton = IconButton(
      iconSize: iconSize,
      icon: Icon(Icons.save),
      color: Colors.white,
      tooltip: 'Save template changes',
      onPressed: lobbyCubit.isTemplateChanged
          ? () => lobbyCubit.saveTemplateChanges()
          : null,
    );

    final removeTemplateButton = IconButton(
      iconSize: iconSize,
      icon: Icon(Icons.delete),
      color: Colors.white,
      tooltip: 'Remove template',
      onPressed: templateId != null
          ? () => PopupsRegistr.registerPopupToShow(popupRemoveName, () {
                showDialog(
                    barrierColor: Colors.black54,
                    context: context,
                    builder: (BuildContext context) {
                      PopupsRegistr.registerPopupDisposer(
                          popupRemoveName, () => Navigator.of(context).pop());
                      return Disposer(
                        dispose: () {
                          PopupsRegistr.unregisterPopupDisposer(
                              popupRemoveName);
                        },
                        child: AlertDialog(
                          title: Text('Are you sure?'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: Container(
                            width: 300,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BottomButton(
                                  onPressed: () {
                                    PopupsRegistr.closePopup(popupRemoveName);
                                  },
                                  text: 'Cancel',
                                ),
                                BottomButton(
                                  onPressed: () {
                                    lobbyCubit.removeTemplate(templateId);
                                    PopupsRegistr.closePopup(popupRemoveName);
                                  },
                                  text: 'Remove',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              })
          : null,
    );
    final defaultIndex =
        templates.toList().indexWhere((temp) => temp.id == templateId);
    final defaultValue = "No template selected";
    final maxItemWidth = 250.0;
    final headerAndIconsWidth = 80.0 + 40 * (defaultIndex > -1 ? 3 : 1);
    final getTemplateSelector = (BoxConstraints constraints) => GameOptionView(
        lablePart1: "Templates:",
        type: GameOptionType.DROPDOWN,
        dropdownItemWidth:
            min(constraints.maxWidth - headerAndIconsWidth, maxItemWidth),
        dropdownOptions: [
          defaultValue,
          ...templates.map((temp) => temp.name).toList()
        ],
        dropdownDefaultValueIdx: defaultIndex != -1 ? defaultIndex + 1 : null,
        onDropdownOptionChangedOrOptionToggled: ((int, String)? val) {
          if (val != null) {
            final templateId =
                val.$1 == 0 ? null : templates.elementAt(val.$1 - 1).id;
            lobbyCubit.setGameTemplate(templateId);
          }
        });

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              getTemplateSelector(constraints),
              createNewTemplateButton,
              if (defaultIndex > -1) ...[
                changeTemplateButton,
                removeTemplateButton,
              ]
            ],
          ));
    });
  }
}

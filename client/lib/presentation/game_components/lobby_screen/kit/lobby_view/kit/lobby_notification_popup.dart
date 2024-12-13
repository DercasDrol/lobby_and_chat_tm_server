import 'package:flutter/material.dart';
import 'package:mars_flutter/presentation/core/disposer.dart';
import 'package:mars_flutter/presentation/game_components/common/popups_register.dart';
import 'package:mars_flutter/presentation/game_components/game_options_screen/game_options_view/kit/bottom_buttons_view/kit/bottom_button.dart';

showLobbyPopup(BuildContext context, String message, Function onOk) {
  final lobbyPopupName = 'lobbyPopup';
  PopupsRegistr.registerPopupToShow(lobbyPopupName, () {
    showDialog(
        barrierColor: Colors.black54,
        context: context,
        builder: (BuildContext context) {
          PopupsRegistr.registerPopupDisposer(lobbyPopupName, () {
            Navigator.of(context).pop();
          });
          return Disposer(
            dispose: () {
              onOk();
              PopupsRegistr.unregisterPopupDisposer(lobbyPopupName);
            },
            child: AlertDialog(
              title: Text(message),
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
                        PopupsRegistr.closePopup(lobbyPopupName);
                      },
                      text: 'Ok',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  });
}

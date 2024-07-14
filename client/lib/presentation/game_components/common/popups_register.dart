import 'dart:async';

class PopupsRegistr {
  //it is needed to close popups if we need to open another popup with the same name, or to close all popups
  static Map<String /**popup name*/, void Function() /**disposer */ >
      _popupsDisposers = {};
  static Map<String /**popup name*/, void Function() /**disposer */ >
      _popupsShowQueue = {};

  static void registerPopupDisposer(
      String popupName, void Function() disposer) {
    _popupsDisposers[popupName] = disposer;
  }

  static void unregisterPopupDisposer(String popupName) {
    _popupsDisposers.remove(popupName);
  }

  static void registerPopupToShow(String popupName, void Function() onShowFn) {
    closePopup(popupName);
    _popupsShowQueue[popupName] = onShowFn;
  }

  static void closePopup(String popupName) {
    _popupsDisposers[popupName]?.call();
    _popupsDisposers.remove(popupName);
  }

  static void closeAllPopups() {
    _popupsDisposers.values.forEach((element) {
      element.call();
    });
    _popupsDisposers.clear();
    _popupsShowQueue.clear();
  }

  static void runPopupRegistr() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_popupsShowQueue.isNotEmpty) {
        final entrie = _popupsShowQueue.entries.first;
        _popupsShowQueue.remove(entrie.key);
        entrie.value.call();
      }
    });
  }
}

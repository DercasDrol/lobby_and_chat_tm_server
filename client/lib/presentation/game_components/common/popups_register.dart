class PopupsRegistr {
  //it is needed to close popups if we need to open another popup with the same name, or to close all popups
  static Map<String /**popup name*/, void Function() /**disposer */ >
      _popupsDisposers = {};
  static void registerPopupDisposer(
      String popupName, void Function() disposer) {
    _popupsDisposers[popupName] = disposer;
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
  }
}

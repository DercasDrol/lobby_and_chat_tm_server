class AmountPresentationInfo {
  final void Function() onDecreaseButtonFn;
  final void Function() onIncreaseButtonFn;
  final void Function() onMaxButtonFn;
  final String? iconPath;
  final int value;

  AmountPresentationInfo({
    required this.iconPath,
    required this.onDecreaseButtonFn,
    required this.onIncreaseButtonFn,
    required this.onMaxButtonFn,
    required this.value,
  });
}

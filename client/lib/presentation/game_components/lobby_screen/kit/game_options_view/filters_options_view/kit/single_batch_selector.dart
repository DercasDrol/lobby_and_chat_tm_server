import 'package:flutter/material.dart';

class SingleBatchSelector<T> extends StatelessWidget {
  final Set<T> items;
  final ValueNotifier<Set<T>> selectedItemsN;
  final Widget Function(T item) itemBuilder;
  final Widget batchTitle;
  const SingleBatchSelector({
    super.key,
    required this.items,
    required this.selectedItemsN,
    required this.itemBuilder,
    required this.batchTitle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        batchTitle,
        Row(
          children: [
            TextButton(
              onPressed: () {
                selectedItemsN.value =
                    [...selectedItemsN.value, ...items].toSet();
              },
              child: Text('All', style: textStyle),
            ),
            Text('|', style: textStyle),
            TextButton(
              onPressed: () {
                selectedItemsN.value = selectedItemsN.value
                    .where((element) => !items.contains(element))
                    .toSet();
              },
              child: Text('None', style: textStyle),
            ),
            Text('|', style: textStyle),
            TextButton(
              onPressed: () {
                selectedItemsN.value = [
                  ...items.difference(selectedItemsN.value
                      .where((element) => items.contains(element))
                      .toSet()),
                  ...selectedItemsN.value
                      .where((element) => !items.contains(element))
                ].toSet();
              },
              child: Text('Invert', style: textStyle),
            ),
          ],
        ),
        ...items
            .map((e) => ValueListenableBuilder<Set<T>>(
                valueListenable: selectedItemsN,
                builder: (context, selectedItems, child) {
                  bool value = selectedItems.contains(e);
                  onChanged(value) {
                    if (value == true) {
                      selectedItemsN.value = [...selectedItems, e].toSet();
                    } else {
                      selectedItemsN.value = selectedItems
                          .where((element) => element != e)
                          .toSet();
                    }
                  }

                  return InkWell(
                    onTap: () {
                      onChanged(!value);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            side: BorderSide(color: Colors.white),
                            value: value,
                            onChanged: (bool? newValue) {
                              onChanged(newValue ?? false);
                            },
                          ),
                          Flexible(child: itemBuilder(e))
                        ],
                      ),
                    ),
                  );
                }))
            .toList(),
      ]),
    );
  }
}

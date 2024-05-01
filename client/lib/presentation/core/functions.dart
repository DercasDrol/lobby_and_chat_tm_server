import 'dart:collection';

String listToString(List<Object?> list) =>
    IterableBase.iterableToFullString(list, '[', ']');

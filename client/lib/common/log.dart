import 'package:logger/logger.dart';
import 'package:mars_flutter/data/api/constants.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  Log._() : super(printer: PrettyPrinter(printTime: true));
  static final instance = _initLog();
  static Log _initLog() {
    Logger.level = !LOGGING_ENABLED
        ? Level.off
        : _levels[LOGGING_LEVEL.toLowerCase()] ?? Level.all;
    return Log._();
  }

  static final _levels = Map<String, Level>.fromIterable(Level.values,
      key: (e) => e.toString().toLowerCase(), value: (e) => e);
}

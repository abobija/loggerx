import 'package:loggerx/loggerx.dart';
import 'package:loggerx/src/log_color.dart';
import 'package:loggerx/src/log_level.dart';
import 'package:loggerx/src/logging.dart';

final _lvlColor = {
  LogLevel.none    : LogColor.cyan,
  LogLevel.error   : LogColor.red,
  LogLevel.warning : LogColor.yellow,
  LogLevel.info    : LogColor.green,
  LogLevel.debug   : LogColor.magenta,
  LogLevel.verbose : LogColor.white,
};

/// Loggerx
class Logger {
  late final Logging _logging;
  late LogLevel _level;

  /// Logger unique name
  final String name;

  /// Set the level of logger
  set level(LogLevel level) => _level = level;

  Logger(this.name, { LogLevel level = LogLevel.verbose }) {
    _logging = logging;
    _level = level;
    _logging.addLogger(this);
  }

  /// Find logger by name.
  /// This is allias for [logging.findLogger]
  static Logger? find(String name) => logging.findLogger(name);

  /// Find logger by name or creates new one
  static Logger findOrCreate(String tag) {
    return find(tag) ?? Logger(tag);
  }

  void _log(Object msg, LogLevel level, { Object? error, StackTrace? stackTrace }) {
    if(!logging.enabled
      || level.index > _level.index 
      || level.index > _logging.level.index) {
      return;
    }

    final filter = _logging.findFilterForLogger(this);

    if(filter != null && level.index > filter.level.index) {
      return;
    }

    if(!(msg is List) && msg is Iterable) { // considering as lazy iterable
      msg = msg.toList();
    }

    final now  = DateTime.now().toLocal();
    final buffer = StringBuffer();

    buffer.writeAll([
      _lvlColor[level],
      '[',
      logging.dateTimeFormat.format(now),
      !logging.milliseconds ? '' : ".${now.millisecond.toString().padLeft(3, '0')}",
      '] [',
      name,
      '] [',
      level.toString().split('.')[1].toUpperCase(),
      '] ',
      msg.toString(),
      LogColor.$null
    ]);

    if(error != null) {
      buffer.write("\n");
      buffer.write("${_lvlColor[level]}[exception] $error${LogColor.$null}");
    }

    if(stackTrace != null) {
      buffer.write("\n");
      buffer.writeln("${_lvlColor[level]}[stacktrace]${LogColor.$null}");
      buffer.write("$stackTrace");
    }

    if(logging.newLine) {
      buffer.write("\n");
    }

    logging.function!(buffer.toString());
  }

  /// Log error [message] with ability to attach [error] and [stackTrace] objects
  void error(Object message, [Object? error, StackTrace? stackTrace]) 
    => _log(message, LogLevel.error, error: error, stackTrace: stackTrace);
  
  /// Log warning [message]
  void warning(Object message) => _log(message, LogLevel.warning);
  
  /// Log info [message]
  void info(Object message) => _log(message, LogLevel.info);
  
  /// Log debug [message]
  void debug(Object message) => _log(message, LogLevel.debug);
  
  /// Log verbose [message]
  void verbose(Object message) => _log(message, LogLevel.verbose);
}
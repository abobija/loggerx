import 'package:loggerx/loggerx.dart';
import 'package:loggerx/src/log_level.dart';
import 'package:loggerx/src/logging.dart';

/// Loggerx
class Logger {
  late final Logging _logging;

  /// Logger unique name
  final String name;

  /// Logger constructor with unique [name]
  Logger(this.name) {
    _logging = logging;
    _logging.addLogger(this);
  }

  /// Find logger by name.
  /// This is allias for [logging.findLogger]
  static Logger? find(String name) => logging.findLogger(name);

  /// Find logger by name or creates new one
  static Logger findOrCreate(String tag) {
    return find(tag) ?? Logger(tag);
  }

  /// Log error [message] with ability to attach [error] and [stackTrace] objects
  void error(Object message, [Object? error, StackTrace? stackTrace]) 
    => _logging.log(this, message, LogLevel.error, error: error, stackTrace: stackTrace);
  
  /// Log warning [message]
  void warning(Object message) => _logging.log(this, message, LogLevel.warning);
  
  /// Log info [message]
  void info(Object message) => _logging.log(this, message, LogLevel.info);
  
  /// Log debug [message]
  void debug(Object message) => _logging.log(this, message, LogLevel.debug);
  
  /// Log verbose [message]
  void verbose(Object message) => _logging.log(this, message, LogLevel.verbose);
}
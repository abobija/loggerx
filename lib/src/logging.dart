import 'dart:async';

import 'package:intl/intl.dart';
import 'package:loggerx/loggerx.dart';
import 'package:loggerx/src/log.dart';
import 'package:loggerx/src/log_color.dart';
import 'package:loggerx/src/log_filter.dart';
import 'package:loggerx/src/log_level.dart';
import 'package:loggerx/src/logger.dart';

final _lvlColor = {
  LogLevel.none    : LogColor.cyan,
  LogLevel.error   : LogColor.red,
  LogLevel.warning : LogColor.yellow,
  LogLevel.info    : LogColor.green,
  LogLevel.debug   : LogColor.magenta,
  LogLevel.verbose : LogColor.white,
};

class Logging {
  /// Status of all loggers
  var enabled = true;

  /// Global level of all loggers
  /// Default is [LogLevel.info]
  var level = LogLevel.info;

  /// DateTime format using in logs.
  /// Default is Hms.
  /// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html for available formats
  var dateTimeFormat = "Hms";

  /// Show or hide milliseconds in datetime
  var milliseconds = true;

  final _loggers = <Logger>[];
  final _filters = <LogFilter>[];
  final _streamCtrl = StreamController<Log>.broadcast();

  /// Logs stream
  Stream<Log> get onLog => _streamCtrl.stream;

  void log(Logger logger, Object msg, LogLevel level, { Object? error, StackTrace? stackTrace }) {
    if(!enabled || level.index > this.level.index) {
      return;
    }

    final filter = findFilterForLogger(logger);

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
      DateFormat(dateTimeFormat).format(now),
      !milliseconds ? '' : ".${now.millisecond.toString().padLeft(3, '0')}",
      '] [',
      logger.name,
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

    _streamCtrl.sink.add(new Log(
      logger,
      now,
      level,
      buffer.toString()
    ));
  }

  /// Returns logger by [name].
  /// If logger does not exists, null will be returned
  Logger? findLogger(String name) {
    for(var l in _loggers) {
      if(l.name == name) {
        return l;
      }
    }

    return null;
  }

  /// Adds new [logger] to existing list of loggers.
  /// If logger with the same name already exists ArgumentError will be thrown.
  void addLogger(Logger logger) {
    if(findLogger(logger.name) != null) {
      throw ArgumentError("Logger with name \"${logger.name}\" already exists");
    }

    _loggers.add(logger);
  }

  LogFilter? _findFilter(String loggerName) {
    for(var f in _filters) {
      if(f.loggerName == loggerName) {
        return f;
      }
    }

    return null;
  }

  /// Returns filter for [logger] or null if not found
  LogFilter? findFilterForLogger(Logger logger) {
    return _findFilter(logger.name);
  }

  /// Creates new filter or change existing one for logger by [loggerName]
  void filter(String loggerName, LogLevel level) {
    var filter = _findFilter(loggerName);

    if(filter == null) {
      filter = LogFilter(loggerName, level);
      _filters.add(filter);
    } else {
      filter.level = level;
    }
  }

  /// Removes filter for logger by [loggerName]
  void removeFilter(String loggerName) {
    _filters.removeWhere((f) => f.loggerName == loggerName);
  }
}
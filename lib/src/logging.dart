import 'dart:io';

import 'package:intl/intl.dart';
import 'package:loggerx/loggerx.dart';
import 'package:loggerx/src/log_filter.dart';
import 'package:loggerx/src/log_level.dart';
import 'package:loggerx/src/logger.dart';

class Logging {
  final _loggers = <Logger>[];
  final _filters = <LogFilter>[];

  /// Status of all loggers.
  /// To disable all loggers set [function] to null
  bool get enabled => function != null;

  /// Global level of all loggers
  /// Default is [LogLevel.info]
  var level = LogLevel.info;

  /// Function that is used for printing logs.
  /// Default is [stderr.write]
  /// Set it to null to completely disable logging
  LoggingFunction? function = stderr.write;

  /// DateTime format using in logs.
  /// Default is [DateFormat.Hms]
  var dateTimeFormat = DateFormat.Hms();

  /// Show or hide milliseconds in datetime
  var milliseconds = true;

  /// Write newline after every log. Default is true
  var newLine = true;

  /// Returns logger by [name].
  /// If logger does not exists, null will be returned
  Logger? findLogger(String name) {
    for(var l in logging._loggers) {
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
  LogFilter? findFilterForLogger(Logger logger) => _findFilter(logger.name);

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
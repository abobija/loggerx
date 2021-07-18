import 'package:loggerx/src/log_level.dart';
import 'package:loggerx/src/logger.dart';

class Log {
  final Logger logger;
  final DateTime dateTime;
  final LogLevel level;
  final String message;

  const Log(
    this.logger,
    this.dateTime,
    this.level,
    this.message
  );
}
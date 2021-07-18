import 'package:loggerx/src/log_level.dart';

class LogFilter {
  final String loggerName;
  LogLevel level;

  LogFilter(this.loggerName, this.level);
}
import 'package:loggerx/loggerx.dart';

void main() {
  // Set global level for all loggers to verbose
  logging.level = LogLevel.verbose;

  // Log with root logger
  log.info("Application successfully started");

  final customLogger = Logger('custom_logger');
  final secondLogger = Logger('second_logger');

  customLogger.debug("This is debug message from custom logger");
  customLogger.warning("Something suspicious happened");
  customLogger.error("Immediately abort everything!");
  customLogger.verbose("Verbose message from custom logger");

  logging.filter('second_logger', LogLevel.info);

  secondLogger.info("Hello from second logger");

  // This will not be displayed because level of second logger is filtered to [LogLevel.info]
  secondLogger.debug("Debug from second logger");

  // But custom logger still can print out verbose logs
  customLogger.verbose("I still can shout out verbose messages");

  // Apply filter for custom_logger
  logging.filter('custom_logger', LogLevel.error);

  customLogger.info("You cant see this, because");
  customLogger.error("Now I can just print errors");

  // Remove filter
  logging.removeFilter('custom_logger');
  customLogger.info('Now I can print infos again');
}

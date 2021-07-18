import 'package:loggerx/loggerx.dart';

void main() {
  // Set global level for all loggers to verbose
  logging.level = LogLevel.verbose;

  // Log with root logger
  log.info("Application successfully started");

  final customLogger = Logger('custom_logger');

  final secondLogger = Logger('second_logger');
  secondLogger.level = LogLevel.info; // Set level of second logger

  customLogger.debug("This is debug message from custom logger");
  customLogger.warning("Something suspicious happened");
  customLogger.error("Immediately abort everything!");
  customLogger.verbose("Verbose message from custom logger");

  secondLogger.info("Hello from second logger");

  // This will not be displayed because level of second logger is [LogLevel.info]
  secondLogger.debug("Debug from second logger");

  // But custom logger still can print out verbose logs
  customLogger.verbose("I still can shout out verbose messages");

  // Instead changing logger level directly we can apply filter
  logging.filter('custom_logger', LogLevel.error);

  customLogger.info("You cant see this, because");
  customLogger.error("Now I can just print errors");

  // Remove filter
  logging.removeFilter('custom_logger');
  customLogger.info('Now I can print infos again');
}
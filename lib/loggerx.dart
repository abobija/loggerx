library loggerx;

import 'package:loggerx/src/logger.dart';
import 'package:loggerx/src/logging.dart';

export 'src/log_level.dart';
export 'src/logger.dart';
export 'src/log.dart';

/// Loggerx configuration object
final logging = Logging();

/// Loggerx root logger
final log = Logger('root');

/// Loggerx logging function prototype
typedef void LoggingFunction(Object? object);
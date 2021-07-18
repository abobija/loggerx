import 'dart:io';

import 'package:loggerx/loggerx.dart';

void main() {
  logging.onLog.listen((log) => stderr.writeln(log.message));
  log.info('Application started');
  
  try {
    throw "Ugly exception";
  } catch(e, s) {
    log.error("Error occurred!", e, s);
  }
}
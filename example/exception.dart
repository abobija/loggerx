import 'package:loggerx/loggerx.dart';

void main() {
  log.info('Application started');

  try {
    throw "Ugly exception";
  } catch (e, s) {
    log.error("Error occurred!", e, s);
  }
}

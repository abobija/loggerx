import 'dart:io';
import 'dart:isolate';

import 'package:loggerx/loggerx.dart';

void main() async {
  logging.level = LogLevel.debug;

  final logger = Logger('isolate_logger');

  final rPort = ReceivePort();

  rPort.listen((message) {
    if (message is SendPort) {
      message.send(logger);
    }
  });

  log.info("Application started");

  final isolate = await Isolate.spawn(task, rPort.sendPort);
  await Future.delayed(Duration(seconds: 1));
  isolate.kill(priority: Isolate.immediate);
  exit(0);
}

void task(SendPort sPort) {
  final rPort = ReceivePort();

  rPort.listen((message) {
    if (message is Logger) {
      message.debug("Hello from isolate");
    }
  });

  sPort.send(rPort.sendPort);
}

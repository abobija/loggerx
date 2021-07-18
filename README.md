# loggerx

[![pub version](https://img.shields.io/pub/v/loggerx?color=blue&logo=dart&style=for-the-badge)](https://pub.dev/packages/loggerx) ![license](https://img.shields.io/github/license/abobija/loggerx?style=for-the-badge)

Tiny but powerful logger with default root logger and ability to create custom loggers with runtime level filtering.

## About

Logger supports 6 levels of logging which are `none`, `error`, `warning`, `info`, `debug` and `verbose`.

![example image](doc/imgs/example.png)

Loggers also supports attaching `exception` and `stackTrace` objects to logging functions that will produce next output:

![exception image](doc/imgs/exception.png)

## Examples

Multiple examples are available in [example](example) folder.

### Basic example

```dart
import 'package:loggerx/loggerx.dart';

void consoleLogging(Log log) {
  stderr.writeln(log.message);
}

void main() {
  logging.onLog.listen(consoleLogging);
  
  log.info("Application started");
}
```

## Author

GitHub: [abobija](https://github.com/abobija)<br>
Homepage: [abobija.com](https://abobija.com)

## License

[MIT](LICENSE)
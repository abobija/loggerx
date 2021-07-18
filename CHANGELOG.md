## 1.3.2

Formating.

## 1.3.1

Using `print` instead of `stderr.writeln` since second one is visible only in Logs in flutter and not in console.

## 1.3.0

Discard streams because Function type still cant be sent to Isolate.
Logger will now use hardcoded `stderr.writeln` function for printing logs.

## 1.2.0

Removed level property from Logger. Filtering with global `logging` variable is still available.

## 1.1.0

For isolate support logging now use stream instead of logging function.

## 1.0.1

Updated description and badges style.

## 1.0.0

Initial release

## 0.0.1-dev.1

* TODO: Describe initial release.

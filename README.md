# PSList Dart Package

A Dart package that allows you to retrieve a list of running processes and check whether a specific process is running on Linux, macOS, and Windows.

## Features

- Retrieve a list of currently running processes.
- Check whether a specific process is currently running.
- Cross-platform support for Linux, macOS, and Windows.

## Installation

In your `pubspec.yaml` file, add the following dependency:

```yaml
dependencies:
  ps_list: ^0.0.2  # Replace with the latest version
```

Then, run:

```bash
$ dart pub get
```

## Usage

```dart
import 'package:ps_list/ps_list.dart';

void main() async {
  // Retrieve a list of all running processes
  List<String> processes = await PSList.getRunningProcesses();

  // Print process details
  for (var process in processes) {
    print('Process: $process');
  }

  // Check if a specific process is running
  String processName = 'my_process';
  bool isRunning = await PSList.isProcessRunning(processName);

  if (isRunning) {
    print('$processName is running.');
  } else {
    print('$processName is not running.');
  }
}
```

## API

### `Future<List<String>> getRunningProcesses()`

Returns a list of strings representing the names of currently running processes.

### `Future<bool> isProcessRunning(String processName)`

Checks if a process with the specified `processName` is currently running.

- Returns `true` if the process is running.
- Returns `false` if the process is not running.

## Compatibility

This package is compatible with Dart 2.12.0 or higher.

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.
library ps_list;

import 'dart:async';
import 'dart:io';

/// Get running processes
class PSList {
  Future<List<String>> _getRunningProcessesUnix() async {
    final result = await Process.run("ps", ["-eo", "comm"]);

    final output = result.stdout
        .toString()
        .trim()
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.split("/").last)
        .toList();

    return output;
  }

  Future<List<String>> _getRunningProcessesWindows() async {
    final result = await Process.run(
      'tasklist /FO CSV | findstr /V /C:"Image Name',
      [],
    );

    final output = result.stdout
        .toString()
        .trim()
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.split("/").last)
        .toList();

    return output;
  }

  /// Returns currently running processes
  ///
  /// Throws [UnsupportedError] if the current platform is not supported
  Future<List<String>> getRunningProcesses() async {
    List<String> ps = [];
    if (Platform.isWindows) {
      ps = await _getRunningProcessesWindows();
    } else if (Platform.isLinux || Platform.isMacOS) {
      ps = await _getRunningProcessesUnix();
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
    print(ps.join("\n"));
    return ps;
  }

  /// Check whether the [process] is running
  ///
  /// Throws [UnsupportedError] if the current platform is not supported
  Future<bool> isRunning(String process) async {
    final ps = await getRunningProcesses();
    return ps
        .where((e) => e.toLowerCase().contains(process.toLowerCase()))
        .isNotEmpty;
  }
}

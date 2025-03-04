library ps_list;

import 'dart:async';
import 'dart:io';

/// Get running processes
class PSList {
  static Future<List<String>> _getRunningProcessesUnix() async {
    final result = await Process.run("ps", ["-eo", "comm"], runInShell: true);

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

  static Future<List<String>> _getRunningProcessesWindows() async {
    final result = await Process.run(
      'tasklist /FO CSV',
      [],
      runInShell: true
    );

    final output = result.stdout
        .toString()
        .trim()
        .split('\n')
        .skip(1)
        .map((row) => row.split(',').first.replaceAll('"', '').trim())
        .toList();

    return output;
  }

  /// Retrieve a list of currently running processes.
  ///
  /// The list is obtained via the appropriate system command for the current
  /// platform:
  ///
  /// - Linux and macOS: `ps -eo comm`
  /// - Windows: `tasklist /FO CSV`
  ///
  /// The returned list contains the names of the processes that are currently
  /// running on the system.
  ///
  /// Throws [UnsupportedError] if the current platform is not supported.
  static Future<List<String>> getRunningProcesses() async {
    List<String> ps = [];
    if (Platform.isWindows) {
      ps = await _getRunningProcessesWindows();
    } else if (Platform.isLinux || Platform.isMacOS) {
      ps = await _getRunningProcessesUnix();
    } else {
      throw UnsupportedError("Unsupported Platform");
    }

    return ps;
  }

  /// Checks if a process is currently running.
  ///
  /// Args:
  ///   [process]: The name of the process to search for.
  ///   [caseSensitive]: Whether the search should be case sensitive.
  ///   [exactMatch]: Whether the search should be an exact match.
  ///
  /// Returns [true] if the process is running and [false] otherwise.
  ///
  /// Throws [UnsupportedError] if the current platform is not supported
  static Future<bool> isProcessRunning(
    String process, {
    bool caseSensitive = false,
    bool exactMatch = false,
  }) async {
    final ps = await getRunningProcesses();
    final result = ps.where((e) {
      if (exactMatch) {
        return e == process.trim();
      } else {
        return caseSensitive
            ? e.contains(process.trim())
            : e.toLowerCase().contains(process.trim().toLowerCase());
      }
    }).isNotEmpty;

    return result;
  }
}

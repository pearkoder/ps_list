import 'package:ps_list/ps_list.dart';
import 'package:test/test.dart';

void main() {
  group('PSList.getRunningProcesses()', () {
    test('Should return a non-empty list', () async {
      final processes = await PSList.getRunningProcesses();
      print("Found ${processes.length} processes");
      expect(processes, isNotEmpty, reason: 'List should not be empty');
    });

    test('Should return a list of strings', () async {
      final processes = await PSList.getRunningProcesses();
      print("Found ${processes.length} processes");
      expect(processes, isA<List<String>>(),
          reason: 'List should be of type List<String>');
    });
  });
}

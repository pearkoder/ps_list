import 'package:ps_list/ps_list.dart';

Future<void> main(List<String> args) async {
  final ps = await PSList.getRunningProcesses();

  print(ps);
}

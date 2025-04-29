import 'package:dolphin_days/data/enums/hive_type_ids.dart';
import 'package:hive/hive.dart';

part 'dolphin_assignment.g.dart';

@HiveType(typeId: HiveTypeIds.dolphinAssignment)
class DolphinAssignment {
  @HiveField(0)
  final String assetPath;

  @HiveField(1)
  final double scale;

  DolphinAssignment({required this.assetPath, required this.scale});
}

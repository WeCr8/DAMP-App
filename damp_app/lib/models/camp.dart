
import 'package:hive/hive.dart';

part 'camp.g.dart';

@HiveType(typeId: 0)
class Camp extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  @HiveField(3)
  bool isAlternate;

  Camp({required this.name, required this.latitude, required this.longitude, this.isAlternate = false});
}

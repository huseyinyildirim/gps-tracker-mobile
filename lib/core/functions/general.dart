import 'package:gps_tracker_mobile/core/functions/base_functions.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class General extends BaseFunctions {
  Future<String> getGUIDv1() async {
    return uuid.v1();
  }

  Future<String> getGUIDv4() async {
    return uuid.v4();
  }
}
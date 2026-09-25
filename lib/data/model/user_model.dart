import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String fullName;

  @HiveField(1)
  Uint8List? imageBytes;

  UserModel({
    required this.fullName,
    this.imageBytes,
  });
}
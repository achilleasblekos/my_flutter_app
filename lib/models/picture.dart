import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Picture{
  final String id;
  final File image;

  Picture({
   required this.image,
   String? id,
  }): id = id ?? uuid.v4();
}
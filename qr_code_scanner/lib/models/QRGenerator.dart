import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QRItems {
  final String label;

  @JsonKey(name: 'assest_path')
  final String assestPath;

  QRItems(this.label, this.assestPath);
}

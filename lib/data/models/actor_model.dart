import 'package:cineswipe/core/app_exports.dart';

part 'actor_model.g.dart';

@HiveType(typeId: 1)
class Actor {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String profileUrl;

  Actor({required this.name, required this.profileUrl});

  Map<String, dynamic> toJson() => {
    'name': name,
    'photo_url': profileUrl,
  };
}

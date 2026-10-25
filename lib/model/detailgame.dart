import 'package:json_annotation/json_annotation.dart';

part 'detailgame.g.dart';

@JsonSerializable()
class MinimumSystemRequirements {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  const MinimumSystemRequirements({
    this.os = 'Tidak tersedia',
    this.processor = 'Tidak tersedia',
    this.memory = 'Tidak tersedia',
    this.graphics = 'Tidak tersedia',
    this.storage = 'Tidak tersedia',
  });

  factory MinimumSystemRequirements.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$MinimumSystemRequirementsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MinimumSystemRequirementsToJson(this);
}

@JsonSerializable()
class Screenshot {
  final int id;
  final String image;

  const Screenshot({
    required this.id,
    this.image = '',
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class DetailGame {
  final int id;
  final String title;
  final String thumbnail;
  final String status;
  final String shortDescription;
  final String description;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String freetogameProfileUrl;
  final MinimumSystemRequirements? minimumSystemRequirements;
  final List<Screenshot> screenshots;

  const DetailGame({
    required this.id,
    this.title = '',
    this.thumbnail = '',
    this.status = '',
    this.shortDescription = '',
    this.description = '',
    this.gameUrl = '',
    this.genre = '',
    this.platform = '',
    this.publisher = '',
    this.developer = '',
    this.releaseDate = '',
    this.freetogameProfileUrl = '',
    this.minimumSystemRequirements,
    this.screenshots = const [],
  });

  factory DetailGame.fromJson(Map<String, dynamic> json) =>
      _$DetailGameFromJson(json);

  Map<String, dynamic> toJson() => _$DetailGameToJson(this);
}
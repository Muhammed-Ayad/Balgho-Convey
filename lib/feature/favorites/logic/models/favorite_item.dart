enum FavoriteType {
  zekr,
  radio;

  static FavoriteType fromString(String value) {
    switch (value) {
      case 'radio':
        return FavoriteType.radio;
      case 'zekr':
      default:
        return FavoriteType.zekr;
    }
  }

  String toValue() {
    switch (this) {
      case FavoriteType.zekr:
        return 'zekr';
      case FavoriteType.radio:
        return 'radio';
    }
  }
}

class FavoriteItem {
  final String id;
  final String title;
  final String content;
  final String extraData;
  final FavoriteType type;
  final DateTime createdAt;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.extraData,
    required this.type,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        extraData: json['extraData'] as String? ?? '',
        type: FavoriteType.fromString(json['type'] as String? ?? 'zekr'),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'extraData': extraData,
        'type': type.toValue(),
        'createdAt': createdAt.toIso8601String(),
      };
}

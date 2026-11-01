class TasbihItem {
  final int id;
  final String title;
  final String? fadl;
  final int count;
  final int target;
  final int totalCount;

  const TasbihItem({
    required this.id,
    required this.title,
    this.fadl,
    this.count = 0,
    this.target = 33,
    this.totalCount = 0,
  });

  TasbihItem copyWith({
    int? count,
    int? target,
    int? totalCount,
  }) {
    return TasbihItem(
      id: id,
      title: title,
      fadl: fadl,
      count: count ?? this.count,
      target: target ?? this.target,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'fadl': fadl,
      'count': count,
      'target': target,
      'totalCount': totalCount,
    };
  }

  factory TasbihItem.fromMap(Map<String, dynamic> map) {
    return TasbihItem(
      id: map['id'] as int,
      title: map['title'] as String,
      fadl: map['fadl'] as String?,
      count: map['count'] as int? ?? 0,
      target: map['target'] as int? ?? 33,
      totalCount: map['totalCount'] as int? ?? 0,
    );
  }
}

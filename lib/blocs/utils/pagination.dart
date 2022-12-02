const kDefaultPaginationLimit = 10;

mixin Pagination<T> {
  // Pagination Variables
  int limit = kDefaultPaginationLimit;
  int offset = 0;
  bool hasMoreData = true;
  List<T> oldList = [];
  QueryParameters queryParameters =
      QueryParameters(kDefaultPaginationLimit, 0, null);

  void nextOffset() {
    offset += limit;
  }

  void resetPagination() {
    hasMoreData = true;
    limit = kDefaultPaginationLimit;
    offset = 0;
    oldList = [];
    queryParameters = QueryParameters(limit, offset, null);
  }

  Future<void> canLoadMoreCheck() async {
    if (oldList.length < offset + limit) {
      hasMoreData = false;
      return;
    }

    nextOffset();
  }

  Future<void> loadMore();
}

/// Customize this according to your server
class QueryParameters {
  final int? limit;
  final int? offset;
  final String? searchKeyword;

  QueryParameters(this.limit, this.offset, this.searchKeyword);

  /// Customize this according to your server
  Map<String, dynamic> toJson() {
    return {
      "filter": {
        if (searchKeyword != null)
          "where": {
            "title": {"regexp": "/.*$searchKeyword.*/i"}
          },
        if (limit != null) "limit": limit,
        if (offset != null) "offset": offset
      }
    };
  }

  QueryParameters.empty()
      : limit = null,
        offset = null,
        searchKeyword = null;

  QueryParameters copyWith({int? limit, int? offset, String? searchKeyword}) =>
      QueryParameters(limit ?? this.limit, offset ?? this.offset,
          searchKeyword ?? this.searchKeyword);
}

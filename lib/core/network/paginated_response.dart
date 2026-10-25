import '../utils/json_utils.dart';

/// One page of a list endpoint (`?page=N`). Lists come back as `data: [...]`
/// with a `meta` object; this also copes with Laravel's nested paginator
/// shape (`data: {data: [...], current_page, last_page}`) so the parsing
/// does not have to change when the real responses are confirmed.
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int? lastPage;
  final int? total;
  final Map<String, dynamic> meta;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    this.lastPage,
    this.total,
    this.meta = const {},
  });

  bool get hasMore => lastPage != null ? currentPage < lastPage! : false;

  factory PaginatedResponse.fromBody(
    dynamic body,
    T Function(Map<String, dynamic>) fromJson, {
    int requestedPage = 1,
    int perPage = 20,
    List<String> listKeys = const ['data'],
  }) {
    final root = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    var rawList = Json.list(root, listKeys);
    var paginator = root;

    // Laravel paginator nested under `data`.
    final nested = Json.map(root, const ['data']);
    if (rawList.isEmpty && nested != null) {
      rawList = Json.list(nested, [...listKeys, 'items', 'results']);
      paginator = nested;
    }

    final meta = Json.map(root, const ['meta']) ?? Json.map(paginator, const ['meta']) ?? paginator;
    final current = Json.intOrNull(meta, const ['current_page', 'page']) ?? requestedPage;
    var last = Json.intOrNull(meta, const ['last_page', 'total_pages', 'pages']);
    final total = Json.intOrNull(meta, const ['total', 'count']);

    final items = [
      for (final item in rawList)
        if (item is Map) fromJson(Map<String, dynamic>.from(item)),
    ];

    if (last == null) {
      final links = Json.map(root, const ['links']);
      final hasNextLink = links != null && links['next'] != null;
      if (hasNextLink) {
        last = current + 1;
      } else if (links == null && items.length >= perPage) {
        // No paging info at all: a full page probably means there is more.
        last = current + 1;
      } else {
        last = current;
      }
    }

    return PaginatedResponse(items: items, currentPage: current, lastPage: last, total: total, meta: meta);
  }
}

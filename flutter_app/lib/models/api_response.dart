class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final PaginationMeta? meta;

  ApiResponse({
    required this.success,
    this.message = '',
    this.data,
    this.errors,
    this.statusCode,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
    int? statusCode,
  }) {
    bool isSuccess = json['status'] == true ||
        json['status'] == 'success' ||
        json['success'] == true ||
        (statusCode != null && statusCode >= 200 && statusCode < 300);

    String msg = json['message']?.toString() ?? '';

    T? parsedData;
    if (fromJsonT != null && (json['data'] != null || json['result'] != null)) {
      parsedData = fromJsonT(json['data'] ?? json['result']);
    } else if (json['data'] is T) {
      parsedData = json['data'] as T;
    }

    PaginationMeta? parsedMeta;
    if (json['meta'] != null && json['meta'] is Map<String, dynamic>) {
      parsedMeta = PaginationMeta.fromJson(json['meta']);
    } else if (json['pagination'] != null && json['pagination'] is Map<String, dynamic>) {
      parsedMeta = PaginationMeta.fromJson(json['pagination']);
    } else if (json['current_page'] != null) {
      parsedMeta = PaginationMeta.fromJson(json);
    }

    return ApiResponse<T>(
      success: isSuccess,
      message: msg,
      data: parsedData,
      errors: json['errors'] is Map<String, dynamic> ? json['errors'] : null,
      statusCode: statusCode,
      meta: parsedMeta,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page']?.toString() ?? '12') ?? 12,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }
}

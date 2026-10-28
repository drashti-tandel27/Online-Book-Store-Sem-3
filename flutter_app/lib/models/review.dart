class Review {
  final int id;
  final int bookId;
  final int? userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final String? createdAt;

  Review({
    required this.id,
    required this.bookId,
    this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    String name = 'Anonymous Reader';
    String? avatar;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      name = json['user']['name']?.toString() ?? name;
      avatar = json['user']['avatar']?.toString();
    } else if (json['user_name'] != null) {
      name = json['user_name'].toString();
    }

    return Review(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      bookId: json['book_id'] is int
          ? json['book_id']
          : int.tryParse(json['book_id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? ''),
      userName: name,
      userAvatar: avatar ?? json['avatar']?.toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      comment: json['comment']?.toString() ?? json['review']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'user_name': userName,
      'avatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}

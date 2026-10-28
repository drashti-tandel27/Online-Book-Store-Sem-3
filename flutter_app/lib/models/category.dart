class Category {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? image;
  final int booksCount;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.image,
    this.booksCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      booksCount: json['books_count'] is int
          ? json['books_count']
          : int.tryParse(json['books_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'books_count': booksCount,
    };
  }
}

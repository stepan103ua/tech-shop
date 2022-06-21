class Category {
  final String? id;
  final String title;
  final String imageUrl;

  Category({this.id, required this.title, required this.imageUrl});

  Category copyWith({String? id, String? title, String? imageUrl}) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String cookingTime;
  final String imageUrl;
  final String authorId;
  final String authorName;
  final int likes;
  final List<String> likedBy;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.cookingTime,
    required this.imageUrl,
    required this.authorId,
    required this.authorName,
    required this.likes,
    required this.likedBy,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      title: data['title'],
      description: data['description'],
      ingredients: List<String>.from(data['ingredients']),
      cookingTime: data['cookingTime'],
      imageUrl: data['imageUrl'],
      authorId: data['authorId'],
      authorName: data['authorName'],
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'cookingTime': cookingTime,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'authorName': authorName,
      'likes': likes,
      'likedBy': likedBy,
    };
  }
}

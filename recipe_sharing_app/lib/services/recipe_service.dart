import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<Recipe>> getAllRecipes() {
    return _db.collection('recipes').orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Recipe.fromMap(doc.id, doc.data())).toList();
      },
    );
  }

  Future<void> addRecipe(Recipe recipe, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      final ref = _storage.ref('recipes/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final newRecipe = recipe.toMap()..addAll({
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });

    await _db.collection('recipes').add(newRecipe);
  }

  Future<void> toggleLike(String recipeId, String userId) async {
    final ref = _db.collection('recipes').doc(recipeId);
    final doc = await ref.get();
    final data = doc.data();
    if (data == null) return;

    final likedBy = List<String>.from(data['likedBy'] ?? []);
    final likes = data['likes'] ?? 0;

    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
      await ref.update({'likedBy': likedBy, 'likes': likes - 1});
    } else {
      likedBy.add(userId);
      await ref.update({'likedBy': likedBy, 'likes': likes + 1});
    }
  }

  Stream<List<Recipe>> getUserRecipes(String userId) {
    return _db
        .collection('recipes')
        .where('authorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Recipe.fromMap(doc.id, doc.data())).toList());
  }
}

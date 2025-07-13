import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Text("By ${recipe.authorName}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Cooking Time: ${recipe.cookingTime}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((e) => Text("• $e")).toList(),
            const SizedBox(height: 20),
            const Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(recipe.description, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    recipe.likedBy.contains(user.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () => recipeService.toggleLike(recipe.id, user.uid),
                ),
                Text("${recipe.likes} likes", style: const TextStyle(fontSize: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

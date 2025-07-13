import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final timeController = TextEditingController();
  final ingredientController = TextEditingController();

  List<String> ingredients = [];
  File? imageFile;
  bool isLoading = false;

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void addIngredient() {
    final ingredient = ingredientController.text.trim();
    if (ingredient.isNotEmpty) {
      setState(() {
        ingredients.add(ingredient);
        ingredientController.clear();
      });
    }
  }

  void submitRecipe() async {
    if (titleController.text.isEmpty || ingredients.isEmpty) return;

    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser!;
    final recipe = Recipe(
      id: '',
      title: titleController.text,
      description: descController.text,
      ingredients: ingredients,
      cookingTime: timeController.text,
      imageUrl: '',
      authorId: user.uid,
      authorName: user.email ?? '',
      likes: 0,
      likedBy: [],
    );

    await context.read<RecipeService>().addRecipe(recipe, imageFile);
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Recipe added!")));
    clearForm();
  }

  void clearForm() {
    titleController.clear();
    descController.clear();
    timeController.clear();
    ingredientController.clear();
    ingredients.clear();
    setState(() => imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _styledTextField(titleController, "Recipe Title"),
            const SizedBox(height: 12),
            _styledTextField(descController, "Description", maxLines: 3),
            const SizedBox(height: 12),
            _styledTextField(timeController, "Cooking Time (e.g., 60 minutes)"),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageFile == null
                    ? const Center(child: Text("Tap to add photo"))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(imageFile!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _styledTextField(ingredientController, "Add ingredient"),
                ),
                IconButton(
                  onPressed: addIngredient,
                  icon: const Icon(Icons.add, color: Colors.deepOrange),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...ingredients.map((e) => Text("• $e")).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: submitRecipe,
                      child: const Text("Submit", style: TextStyle(fontSize: 16)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

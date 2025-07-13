import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthService>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: recipeService.getUserRecipes(user.uid),
        builder: (context, snapshot) {
          final recipes = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 12),
                Text(user.email ?? '', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text("Recipes Shared: ${recipes.length}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("My Recipes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                ...recipes.map((r) => RecipeCard(recipe: r)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

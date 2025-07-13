import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RecipeList(),
    const AddRecipeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add Recipe'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class RecipeList extends StatelessWidget {
  const RecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here if needed
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: recipeService.getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'No recipes found.\nTry adding some!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // For demo: take first 3 recipes as featured
          final featuredRecipes = recipes.length >= 3 ? recipes.sublist(0, 3) : recipes;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find your favorite recipes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontal featured recipes list
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredRecipes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 160,
                        child: RecipeCard(recipe: featuredRecipes[index]),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'All Recipes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                // Expanded ListView for full recipes list
                Expanded(
                  child: ListView.separated(
                    itemCount: recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return RecipeCard(recipe: recipes[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

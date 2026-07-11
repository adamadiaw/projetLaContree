import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../../home/widgets/activity_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recharge les favoris quand on revient sur la page
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });
    final data = await db.getFavoriteActivities();
    setState(() {
      favorites = data;
      isLoading = false;
    });
  }

  // Méthode pour rafraîchir la liste quand un favori est supprimé
  void _onFavoriteRemoved() {
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: _loadFavorites,
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : favorites.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun favori',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ajoutez des activités en favoris',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadFavorites,
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final activity = favorites[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ActivityCard(
                            activity: activity,
                            isInFavoritesPage: true,  // ← Nouveau paramètre
                            onFavoriteRemoved: _onFavoriteRemoved,
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
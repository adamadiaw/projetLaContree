import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/activity_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> allActivities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadActivities();
    searchController.addListener(_filterActivities);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterActivities);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    final data = await db.getActivities();
    setState(() {
      allActivities = data;
      filteredActivities = data;
      isLoading = false;
    });
  }

  void _filterActivities() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredActivities = allActivities;
      } else {
        filteredActivities = allActivities.where((activity) {
          final title = activity['title'].toString().toLowerCase();
          final description = activity['description'].toString().toLowerCase();
          return title.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Contrée'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'bienvenue'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'sous_titre'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Barre de recherche
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une activité...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Choses à faire',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredActivities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun résultat',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Essayez un autre mot-clé',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredActivities.length,
                          itemBuilder: (context, index) {
                            final activity = filteredActivities[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ActivityCard(
                                activity: activity,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/tour_card.dart';
import '../../../main.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> allTours = [];
  List<Map<String, dynamic>> filteredTours = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTours();
    searchController.addListener(_filterTours);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterTours);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTours() async {
    final data = await db.getTours();
    setState(() {
      allTours = data;
      filteredTours = data;
      isLoading = false;
    });
  }

  void _filterTours() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredTours = allTours;
      } else {
        filteredTours = allTours.where((tour) {
          final title = tour['title'].toString().toLowerCase();
          final description = tour['description'].toString().toLowerCase();
          final guide = tour['guide'].toString().toLowerCase();
          return title.contains(query) ||
              description.contains(query) ||
              guide.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visites Guidées'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (scaffoldKey.currentState?.isDrawerOpen == false) {
              scaffoldKey.currentState?.openDrawer();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Rechercher une visite...',
                hintStyle: theme.textTheme.bodySmall,
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTours.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: theme.colorScheme.onSurface,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucune visite trouvée',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Essayez un autre mot-clé',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTours.length,
                          itemBuilder: (context, index) {
                            final tour = filteredTours[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TourCard(tour: tour),
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
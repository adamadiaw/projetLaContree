import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/hotel_card.dart';
import '../../../main.dart'; // Import pour scaffoldKey

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> allHotels = [];
  List<Map<String, dynamic>> filteredHotels = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHotels();
    searchController.addListener(_filterHotels);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterHotels);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHotels() async {
    final data = await db.getHotels();
    setState(() {
      allHotels = data;
      filteredHotels = data;
      isLoading = false;
    });
  }

  void _filterHotels() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredHotels = allHotels;
      } else {
        filteredHotels = allHotels.where((hotel) {
          final name = hotel['name'].toString().toLowerCase();
          final description = hotel['description'].toString().toLowerCase();
          return name.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hôtels'),
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
              decoration: InputDecoration(
                hintText: 'Rechercher un hôtel...',
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

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredHotels.isEmpty
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
                                'Aucun hôtel trouvé',
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
                          itemCount: filteredHotels.length,
                          itemBuilder: (context, index) {
                            final hotel = filteredHotels[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HotelCard(hotel: hotel),
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
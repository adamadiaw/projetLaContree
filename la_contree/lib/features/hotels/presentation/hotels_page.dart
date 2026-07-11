import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/hotel_card.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    final data = await db.getHotels();
    setState(() {
      hotels = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hôtels'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hotels.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun hôtel disponible',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotels[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HotelCard(hotel: hotel),
                      );
                    },
                  ),
      ),
    );
  }
}
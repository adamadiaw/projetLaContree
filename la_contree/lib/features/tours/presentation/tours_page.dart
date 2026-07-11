import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/tour_card.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> {
  final AppDatabase db = AppDatabase();
  List<Map<String, dynamic>> tours = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  Future<void> _loadTours() async {
    final data = await db.getTours();
    setState(() {
      tours = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visites Guidées'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tours.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune visite disponible',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: tours.length,
                    itemBuilder: (context, index) {
                      final tour = tours[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TourCard(tour: tour),
                      );
                    },
                  ),
      ),
    );
  }
}
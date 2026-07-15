import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_helper.dart';
import '../../../data/database/database.dart';

class ActivityDetailPage extends StatefulWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailPage({
    super.key,
    required this.activity,
  });

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late bool isFavorite;
  final db = AppDatabase();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.activity['isFavorite'] == 1;
  }

  Future<void> _toggleFavorite() async {
    final newValue = !isFavorite;
    await db.toggleFavorite(widget.activity['id'], newValue);
    setState(() {
      isFavorite = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = widget.activity['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity['title']),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ImageHelper.buildImage(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.activity['title'],
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              widget.activity['description'],
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
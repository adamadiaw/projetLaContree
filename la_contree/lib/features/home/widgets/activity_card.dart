import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_helper.dart';
import '../../../data/database/database.dart';
import '../../activity/presentation/activity_detail_page.dart';

class ActivityCard extends StatefulWidget {
  final Map<String, dynamic> activity;
  final bool isInFavoritesPage;
  final VoidCallback? onFavoriteRemoved;

  const ActivityCard({
    super.key,
    required this.activity,
    this.isInFavoritesPage = false,
    this.onFavoriteRemoved,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
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

    if (widget.isInFavoritesPage && !newValue && widget.onFavoriteRemoved != null) {
      widget.onFavoriteRemoved!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = widget.activity['imageUrl'] ?? '';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailPage(
              activity: widget.activity,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageHelper.buildImage(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity['title'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.activity['description'],
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Voir Plus',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.secondary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
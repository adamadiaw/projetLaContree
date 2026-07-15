import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final AppDatabase db = AppDatabase();
  final MapController _mapController = MapController();

  List<Map<String, dynamic>> allPlaces = [];
  bool isLoading = true;
  LatLng? _currentPosition;
  // ✅ Variable supprimée car inutilisée

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _getCurrentLocation();
  }

  Future<void> _loadPlaces() async {
    try {
      final activities = await db.getActivities();
      final hotels = await db.getHotels();
      final tours = await db.getTours();

      final all = <Map<String, dynamic>>[];

      for (var item in activities) {
        if (item['latitude'] != null && item['longitude'] != null) {
          item['type'] = 'activity';
          all.add(item);
        }
      }

      for (var item in hotels) {
        if (item['latitude'] != null && item['longitude'] != null) {
          item['type'] = 'hotel';
          all.add(item);
        }
      }

      for (var item in tours) {
        if (item['latitude'] != null && item['longitude'] != null) {
          item['type'] = 'tour';
          all.add(item);
        }
      }

      setState(() {
        allPlaces = all;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des lieux: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentPosition!, 15.0);
    } catch (e) {
      print('Erreur de localisation: $e');
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15.0);
    } else {
      _getCurrentLocation();
    }
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'activity':
        return AppColors.primary;
      case 'hotel':
        return AppColors.secondary;
      case 'tour':
        return AppColors.accentDark;
      default:
        return AppColors.primary;
    }
  }

  IconData _getMarkerIcon(String type) {
    switch (type) {
      case 'activity':
        return Icons.landscape;
      case 'hotel':
        return Icons.hotel;
      case 'tour':
        return Icons.tour;
      default:
        return Icons.location_on;
    }
  }

  String _getPlaceName(Map<String, dynamic> place) {
    return place['title'] ?? place['name'] ?? 'Lieu';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: _centerOnUser,
            icon: const Icon(Icons.my_location),
            tooltip: 'Centrer sur ma position',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition ?? const LatLng(14.6833, -17.4410),
                    initialZoom: 13.0,
                    onTap: (_, __) {},
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.la_contree',
                    ),
                    MarkerLayer(
                      markers: allPlaces.map((place) {
                        return Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(
                            place['latitude'],
                            place['longitude'],
                          ),
                          child: GestureDetector(
                            onTap: () => _showPlaceDetails(context, place),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getMarkerColor(place['type']),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getMarkerIcon(place['type']),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 30,
                            height: 30,
                            point: _currentPosition!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegendItem(
                          color: AppColors.primary,
                          icon: Icons.landscape,
                          label: 'Activités',
                        ),
                        _buildLegendItem(
                          color: AppColors.secondary,
                          icon: Icons.hotel,
                          label: 'Hôtels',
                        ),
                        _buildLegendItem(
                          color: AppColors.accentDark,
                          icon: Icons.tour,
                          label: 'Visites',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 10,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showPlaceDetails(BuildContext context, Map<String, dynamic> place) {
    final theme = Theme.of(context);
    final name = _getPlaceName(place);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMarkerIcon(place['type']),
                  color: _getMarkerColor(place['type']),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              place['description'] ?? '',
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Fermer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
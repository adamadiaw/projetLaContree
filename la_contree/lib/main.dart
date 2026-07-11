import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart'; // ← Import pour les couleurs
import 'features/home/presentation/home_page.dart';
import 'features/hotels/presentation/hotels_page.dart';
import 'features/tours/presentation/tours_page.dart';
import 'features/favorites/presentation/favorites_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/bookings/presentation/bookings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      child: const LaContreeApp(),
    ),
  );
}

class LaContreeApp extends StatelessWidget {
  const LaContreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'La Contrée',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const HotelsPage(),
    const ToursPage(),
    const BookingsPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hôtels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tour),
            label: 'Visites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
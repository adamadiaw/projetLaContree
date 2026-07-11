import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../../admin/presentation/admin_login_page.dart';
import '../../admin/presentation/admin_panel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AppDatabase db = AppDatabase();
  int favoriteCount = 0;
  int bookingCount = 0;
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final favorites = await db.getFavoriteActivities();
    final bookings = await db.getBookings();
    setState(() {
      favoriteCount = favorites.length;
      bookingCount = bookings.length;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primary,
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar et Nom
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isAdmin ? 'Administrateur' : 'Voyageur',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAdmin
                          ? 'Mode administration activé'
                          : 'Explorez le Sénégal avec La Contrée',
                      style: TextStyle(
                        fontSize: 14,
                        color: isAdmin ? AppColors.secondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Statistiques
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.favorite,
                      label: 'Favoris',
                      value: favoriteCount.toString(),
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.book_online,
                      label: 'Réservations',
                      value: bookingCount.toString(),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Menu
              const Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Card(
                child: Column(
                  children: [
                    // Bouton Administration
                    ListTile(
                      leading: Icon(
                        Icons.admin_panel_settings,
                        color: AppColors.secondary,
                      ),
                      title: Text(
                        isAdmin ? 'Administration' : 'Mode Administrateur',
                        style: TextStyle(
                          color: isAdmin ? AppColors.secondary : AppColors.textPrimary,
                          fontWeight: isAdmin ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAdmin)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ACTIF',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () => _handleAdminAccess(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: AppColors.primary,
                      ),
                      title: const Text('Changer la langue'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showLanguageDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
                      title: const Text('À propos'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAdminAccess(BuildContext context) {
    if (isAdmin) {
      // Si déjà admin, on va au panneau d'administration
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPanel(),
        ),
      );
    } else {
      // Sinon, on demande le mot de passe
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminLoginPage(),
        ),
      ).then((result) {
        if (result == true) {
          setState(() {
            isAdmin = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Mode Administrateur activé'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      });
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              context,
              'Français',
              '🇫🇷',
              const Locale('fr'),
            ),
            _buildLanguageTile(
              context,
              'English',
              '🇬🇧',
              const Locale('en'),
            ),
            _buildLanguageTile(
              context,
              'Español',
              '🇪🇸',
              const Locale('es'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String label,
    String flag,
    Locale locale,
  ) {
    return ListTile(
      leading: Text(flag),
      title: Text(label),
      trailing: context.locale.languageCode == locale.languageCode
          ? Icon(
              Icons.check_circle,
              color: AppColors.success,
            )
          : null,
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('À propos de La Contrée'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌍 La Contrée',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Votre guide de voyage au Sénégal.',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isAdmin = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Déconnexion effectuée'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
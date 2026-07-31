# la_contree  - Guide de voyage au Sénégal
Application mobile de tourisme permettant de découvrir le Sénégal, réserver des hôtels et des visites guidées.


## Fonctionnalités

| Fonctionnalité | Description |
|----------------|-------------|
| **Accueil** | Découvrez les activités incontournables |
| **Hôtels** | Recherchez et réservez des hôtels |
| **Visites** | Réservez des visites guidées avec des guides locaux |
| **Carte** | Visualisez tous les lieux sur une carte interactive |
| **Favoris** | Sauvegardez vos coups de cœur |
| **Réservations** | Gérez vos réservations |
| **Profil** | Statistiques, langue, mode sombre |
| **Admin** | Ajoutez/modifiez du contenu (mot de passe : `admin123`) |


## Technologies

| Technologie | Utilisation |
|-------------|-------------|
| Flutter | Framework mobile |
| SQLite | Base de données locale |
| OpenStreetMap | Cartographie |
| SharedPreferences | Sauvegarde des préférences |


## Installation

### Prérequis
- Flutter 3.x
- Android Studio / VS Code
- Téléphone Android ou émulateur

### Cloner et lancer

```bash
git clone repository
cd project_name
flutter pub get
flutter run
```

## Structure
lib/
├── core/               # Cœur de l'app
│   ├── services/       # Services (notifications, etc.)
│   ├── theme/          # Thème et couleurs
│   └── utils/          # Utilitaires (images, etc.)
├── data/               # Données
│   └── database/       # SQLite
├── features/           # Fonctionnalités
│   ├── activity/       # Activités
│   ├── admin/          # Administration
│   ├── bookings/       # Réservations
│   ├── favorites/      # Favoris
│   ├── home/           # Accueil
│   ├── hotels/         # Hôtels
│   ├── map/            # Carte
│   ├── profile/        # Profil
│   └── tours/          # Visites guidées
└── main.dart           # Point d'entrée

# Adama Diaw
Projet réalisé dans le cadre du développement d'une application de tourisme.
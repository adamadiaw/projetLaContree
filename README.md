# LaContree  - Guide de voyage au Sénégal

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


### Lancement

```bash
git clone repository
cd project_name
flutter pub get
flutter run
```

## Structure du projet

- **`lib/`** : Code source de l'application Flutter
  - **`core/`** : Éléments partagés et configuration globale du projet
    - **`services/`** : Services transversaux (gestion des notifications, etc.)
    - **`theme/`** : Définition des thèmes graphiques et palettes de couleurs
    - **`utils/`** : Fonctions utilitaires globales (gestion des images, etc.)
  - **`data/`** : Couche de gestion des données
    - **`database/`** : Configuration et gestion de la base de données locale SQLite
  - **`features/`** : Modules et fonctionnalités de l'application (approche Feature-First)
    - **`activity/`** : Gestion et affichage des activités
    - **`admin/`** : Panneau et outils d'administration
    - **`bookings/`** : Système de gestion des réservations
    - **`favorites/`** : Gestion des éléments favoris
    - **`home/`** : Écran d'accueil principal
    - **`hotels/`** : Recherche et détails des hôtels
    - **`map/`** : Fonctionnalités de cartographie et de géolocalisation
    - **`profile/`** : Gestion du profil utilisateur et des paramètres
    - **`tours/`** : Gestion des visites guidées
  - **`main.dart`** : Point d'entrée principal de l'application


<div align="right"><code>Adama Diaw</code></div>
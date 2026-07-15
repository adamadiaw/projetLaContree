import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  
  Database? _database;
  
  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final path = p.join(dbFolder.path, 'la_contree.db');

    // ✅ FORCER la suppression de l'ancienne base
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('🗑️ Ancienne base supprimée');
    }

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('📦 Création de la base de données version $version');

    // Table activities
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imageUrl TEXT,
        isFavorite INTEGER DEFAULT 0,
        latitude REAL,
        longitude REAL
      )
    ''');

    // Table hotels
    await db.execute('''
      CREATE TABLE hotels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price INTEGER,
        rating REAL,
        imageUrl TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');

    // Table tours
    await db.execute('''
      CREATE TABLE tours (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        guide TEXT,
        duration TEXT,
        price INTEGER,
        imageUrl TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');

    // Table bookings
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        itemId INTEGER,
        itemName TEXT,
        date TEXT,
        status TEXT
      )
    ''');

    // Insertion des activités avec coordonnées
    await db.insert('activities', {
      'title': 'Un tour au marché Kermel',
      'description': 'Détruit par un incendie en 1995, le bâtiment qui abrite le marché Kermel a été reconstruit à l\'identique.',
      'imageUrl': 'https://images.unsplash.com/photo-1596178060671-7a80dc8059ea?w=400&h=300&fit=crop',
      'latitude': 14.6833,
      'longitude': -17.4410,
    });

    await db.insert('activities', {
      'title': 'Une petite visite sur l\'île de Gorée',
      'description': 'Imposante de ne pas abîmer la célèbre île de Gorée, cet endroit pénétré de richesses culturelles et de traditionnalité.',
      'imageUrl': 'https://images.unsplash.com/photo-1596178060671-7a80dc8059ea?w=400&h=300&fit=crop',
      'latitude': 14.6667,
      'longitude': -17.4000,
    });

    await db.insert('activities', {
      'title': 'Grimper jusqu\'au phare des Mamelles',
      'description': 'Les Mamelles, ce sont deux colonnes rocheuses des sables de Dakar...',
      'imageUrl': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=400&h=300&fit=crop',
      'latitude': 14.7167,
      'longitude': -17.4833,
    });

    // Insertion des hôtels avec coordonnées
    await db.insert('hotels', {
      'name': 'Hôtel Teranga',
      'description': 'Vue imprenable sur l\'océan, à 5 min de la plage. Piscine, spa et restaurant gastronomique.',
      'price': 80,
      'rating': 4.5,
      'imageUrl': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop',
      'latitude': 14.6900,
      'longitude': -17.4500,
    });

    await db.insert('hotels', {
      'name': 'Résidence Almadies',
      'description': 'Confort moderne en plein cœur de Dakar. Idéal pour les voyageurs d\'affaires et les familles.',
      'price': 65,
      'rating': 4.2,
      'imageUrl': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400&h=300&fit=crop',
      'latitude': 14.7000,
      'longitude': -17.4600,
    });

    await db.insert('hotels', {
      'name': 'Auberge Ngor',
      'description': 'Charme authentique près de la plage. Petit déjeuner inclus, ambiance conviviale.',
      'price': 45,
      'rating': 4.0,
      'imageUrl': 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=400&h=300&fit=crop',
      'latitude': 14.6667,
      'longitude': -17.4167,
    });

    // Insertion des visites avec coordonnées
    await db.insert('tours', {
      'title': 'Découverte de Dakar',
      'description': 'Explorez la capitale sénégalaise à travers ses quartiers animés, ses marchés colorés et ses monuments historiques.',
      'guide': 'Abdoulaye',
      'duration': '4h',
      'price': 35,
      'imageUrl': 'https://images.unsplash.com/photo-1523731407965-2430cd12f5e4?w=400&h=300&fit=crop',
      'latitude': 14.6833,
      'longitude': -17.4410,
    });

    await db.insert('tours', {
      'title': 'Île de Gorée',
      'description': 'Voyage dans l\'histoire avec une visite guidée de l\'île de Gorée.',
      'guide': 'Marie',
      'duration': '3h',
      'price': 25,
      'imageUrl': 'https://images.unsplash.com/photo-1596178060671-7a80dc8059ea?w=400&h=300&fit=crop',
      'latitude': 14.6667,
      'longitude': -17.4000,
    });

    await db.insert('tours', {
      'title': 'Lac Rose',
      'description': 'Excursion vers le célèbre Lac Rose, connu pour ses eaux rosées.',
      'guide': 'Ousmane',
      'duration': '6h',
      'price': 50,
      'imageUrl': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=400&h=300&fit=crop',
      'latitude': 14.8333,
      'longitude': -17.2333,
    });

    print('✅ Base de données créée avec succès');
  }

  // Activities
  Future<List<Map<String, dynamic>>> getActivities() async {
    final db = await database;
    return await db.query('activities');
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    await db.update(
      'activities',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteActivities() async {
    final db = await database;
    return await db.query(
      'activities',
      where: 'isFavorite = 1',
    );
  }

  // Hotels
  Future<List<Map<String, dynamic>>> getHotels() async {
    final db = await database;
    return await db.query('hotels');
  }

  // Tours
  Future<List<Map<String, dynamic>>> getTours() async {
    final db = await database;
    return await db.query('tours');
  }

  // Bookings
  Future<void> addBooking({
    required String type,
    required int itemId,
    required String itemName,
    required String date,
  }) async {
    final db = await database;
    await db.insert('bookings', {
      'type': type,
      'itemId': itemId,
      'itemName': itemName,
      'date': date,
      'status': 'confirmée',
    });
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return await db.query('bookings');
  }

  Future<void> cancelBooking(int id) async {
    final db = await database;
    await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
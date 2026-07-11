import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table activities
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imageUrl TEXT,
        isFavorite INTEGER DEFAULT 0
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
        imageUrl TEXT
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
        imageUrl TEXT
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

    // Insertion des activités
    await db.insert('activities', {
      'title': 'Un tour au marché Kermel',
      'description': 'Détruit par un incendie en 1995, le bâtiment qui abrite le marché Kermel a été reconstruit à l\'identique.',
      'imageUrl': 'assets/images/kermel.jpg',
    });

    await db.insert('activities', {
      'title': 'Une petite visite sur l\'île de Gorée',
      'description': 'Imposante de ne pas abîmer la célèbre île de Gorée, cet endroit pénétré de richesses culturelles et de traditionnalité.',
      'imageUrl': 'assets/images/goree.jpg',
    });

    await db.insert('activities', {
      'title': 'Grimper jusqu\'au phare des Mamelles',
      'description': 'Les Mamelles, ce sont deux colonnes rocheuses des sables de Dakar...',
      'imageUrl': 'assets/images/mamelles.jpg',
    });

    // Insertion des hôtels
    await db.insert('hotels', {
      'name': 'Hôtel Teranga',
      'description': 'Vue imprenable sur l\'océan, à 5 min de la plage. Piscine, spa et restaurant gastronomique.',
      'price': 80,
      'rating': 4.5,
      'imageUrl': 'assets/images/teranga.jpg',
    });

    await db.insert('hotels', {
      'name': 'Résidence Almadies',
      'description': 'Confort moderne en plein cœur de Dakar. Idéal pour les voyageurs d\'affaires et les familles.',
      'price': 65,
      'rating': 4.2,
      'imageUrl': 'assets/images/almadies.jpg',
    });

    await db.insert('hotels', {
      'name': 'Auberge Ngor',
      'description': 'Charme authentique près de la plage. Petit déjeuner inclus, ambiance conviviale.',
      'price': 45,
      'rating': 4.0,
      'imageUrl': 'assets/images/ngor.jpg',
    });

    // Insertion des visites
    await db.insert('tours', {
      'title': 'Découverte de Dakar',
      'description': 'Explorez la capitale sénégalaise à travers ses quartiers animés, ses marchés colorés et ses monuments historiques.',
      'guide': 'Abdoulaye',
      'duration': '4h',
      'price': 35,
      'imageUrl': 'assets/images/dakar_tour.jpg',
    });

    await db.insert('tours', {
      'title': 'Île de Gorée',
      'description': 'Voyage dans l\'histoire avec une visite guidée de l\'île de Gorée.',
      'guide': 'Marie',
      'duration': '3h',
      'price': 25,
      'imageUrl': 'assets/images/goree_tour.jpg',
    });

    await db.insert('tours', {
      'title': 'Lac Rose',
      'description': 'Excursion vers le célèbre Lac Rose, connu pour ses eaux rosées.',
      'guide': 'Ousmane',
      'duration': '6h',
      'price': 50,
      'imageUrl': 'assets/images/lac_rose.jpg',
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE hotels (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          price INTEGER,
          rating REAL,
          imageUrl TEXT
        )
      ''');

      await db.insert('hotels', {
        'name': 'Hôtel Teranga',
        'description': 'Vue imprenable sur l\'océan, à 5 min de la plage. Piscine, spa et restaurant gastronomique.',
        'price': 80,
        'rating': 4.5,
        'imageUrl': 'assets/images/teranga.jpg',
      });

      await db.insert('hotels', {
        'name': 'Résidence Almadies',
        'description': 'Confort moderne en plein cœur de Dakar. Idéal pour les voyageurs d\'affaires et les familles.',
        'price': 65,
        'rating': 4.2,
        'imageUrl': 'assets/images/almadies.jpg',
      });

      await db.insert('hotels', {
        'name': 'Auberge Ngor',
        'description': 'Charme authentique près de la plage. Petit déjeuner inclus, ambiance conviviale.',
        'price': 45,
        'rating': 4.0,
        'imageUrl': 'assets/images/ngor.jpg',
      });
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE tours (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          guide TEXT,
          duration TEXT,
          price INTEGER,
          imageUrl TEXT
        )
      ''');

      await db.insert('tours', {
        'title': 'Découverte de Dakar',
        'description': 'Explorez la capitale sénégalaise à travers ses quartiers animés, ses marchés colorés et ses monuments historiques.',
        'guide': 'Abdoulaye',
        'duration': '4h',
        'price': 35,
        'imageUrl': 'assets/images/dakar_tour.jpg',
      });

      await db.insert('tours', {
        'title': 'Île de Gorée',
        'description': 'Voyage dans l\'histoire avec une visite guidée de l\'île de Gorée.',
        'guide': 'Marie',
        'duration': '3h',
        'price': 25,
        'imageUrl': 'assets/images/goree_tour.jpg',
      });

      await db.insert('tours', {
        'title': 'Lac Rose',
        'description': 'Excursion vers le célèbre Lac Rose, connu pour ses eaux rosées.',
        'guide': 'Ousmane',
        'duration': '6h',
        'price': 50,
        'imageUrl': 'assets/images/lac_rose.jpg',
      });
    }

    if (oldVersion < 4) {
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
    }
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
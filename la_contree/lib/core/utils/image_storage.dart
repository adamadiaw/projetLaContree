import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class ImageStorage {
  // Copier une image depuis la galerie vers le stockage de l'app
  static Future<String?> saveImageToAppStorage(XFile imageFile) async {
    try {
      // Récupérer le dossier de l'app
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'images'));
      
      // Créer le dossier s'il n'existe pas
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Générer un nom unique
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = p.join(imagesDir.path, fileName);

      // Copier le fichier
      final sourceFile = File(imageFile.path);
      await sourceFile.copy(filePath);

      // Retourner le chemin absolu du fichier copié
      return filePath;
    } catch (e) {
      print('Erreur lors de la copie de l\'image: $e');
      return null;
    }
  }

  // Vérifier si un fichier existe encore
  static Future<bool> fileExists(String path) async {
    try {
      return await File(path).exists();
    } catch (e) {
      return false;
    }
  }
}
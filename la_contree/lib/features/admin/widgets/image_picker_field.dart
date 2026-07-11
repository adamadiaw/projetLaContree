import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_storage.dart';

class ImagePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  const ImagePickerField({
    super.key,
    required this.controller,
    this.hintText,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        // Sauvegarder l'image dans le stockage de l'app
        final savedPath = await ImageStorage.saveImageToAppStorage(image);
        
        if (savedPath != null) {
          setState(() {
            _imageFile = File(savedPath);
          });
          widget.controller.text = savedPath;
        } else {
          // Fallback: utiliser le chemin original
          final file = File(image.path);
          setState(() {
            _imageFile = file;
          });
          widget.controller.text = image.path;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si le fichier existe encore
    final String currentPath = widget.controller.text;
    if (currentPath.isNotEmpty && !currentPath.startsWith('http')) {
      // Si c'est un chemin local, vérifier qu'il existe
      final file = File(currentPath);
      if (file.existsSync()) {
        if (_imageFile?.path != currentPath) {
          _imageFile = file;
        }
      }
    }

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          // Aperçu de l'image
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.image,
                            color: AppColors.primary.withValues(alpha: 0.5),
                            size: 30,
                          ),
                        );
                      },
                    )
                  : (currentPath.startsWith('http')
                      ? Image.network(
                          currentPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.image,
                                color: AppColors.primary.withValues(alpha: 0.5),
                                size: 30,
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.image,
                            color: AppColors.primary.withValues(alpha: 0.5),
                            size: 30,
                          ),
                        )),
            ),
          ),
          const SizedBox(width: 8),

          // Champ URL
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'URL de l\'image ou sélectionnez',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Bouton Galerie
          SizedBox(
            height: 50,
            width: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.photo_library, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
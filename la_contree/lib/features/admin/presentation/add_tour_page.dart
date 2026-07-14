import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_helper.dart';
import '../../../data/database/database.dart';
import '../widgets/image_picker_field.dart';

class AddTourPage extends StatefulWidget {
  const AddTourPage({super.key});

  @override
  State<AddTourPage> createState() => _AddTourPageState();
}

class _AddTourPageState extends State<AddTourPage> {
  final AppDatabase db = AppDatabase();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _guideController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _guideController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveTour() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final database = await db.database;

    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty) {
      imageUrl = ImageHelper.defaultImageUrl;
    }

    await database.insert('tours', {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'guide': _guideController.text.trim(),
      'duration': _durationController.text.trim(),
      'price': int.parse(_priceController.text.trim()),
      'imageUrl': imageUrl,
    });

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Visite ajoutée avec succès'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une visite guidée'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre de la visite *',
                    hintText: 'Ex: Découverte de Dakar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Décrivez la visite...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _guideController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du guide *',
                          hintText: 'Ex: Abdoulaye',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Guide requis';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: 'Durée *',
                          hintText: 'Ex: 4h',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Durée requise';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Prix (€) *',
                    hintText: 'Ex: 35',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Prix requis';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Entrez un nombre valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ImagePickerField(
                  controller: _imageUrlController,
                  hintText: 'URL de l\'image ou sélectionnez depuis la galerie',
                ),
                const SizedBox(height: 8),
                Text(
                  '📱 Appuyez sur le bouton 📷 pour choisir une image dans votre galerie',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveTour,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        : const Text('Ajouter la visite'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
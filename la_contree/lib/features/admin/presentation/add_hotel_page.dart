import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/database.dart';
import '../widgets/image_picker_field.dart';

class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  final AppDatabase db = AppDatabase();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveHotel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final database = await db.database;

    String imageUrl = _imageUrlController.text.trim();
    if (imageUrl.isEmpty ||
        (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://'))) {
      imageUrl =
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop';
    }

    await database.insert('hotels', {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': int.parse(_priceController.text.trim()),
      'rating': double.parse(_ratingController.text.trim()),
      'imageUrl': imageUrl,
    });

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Hôtel ajouté avec succès'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un hôtel'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'hôtel *',
                    hintText: 'Ex: Hôtel Teranga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Décrivez l\'hôtel...',
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
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Prix (€) *',
                          hintText: 'Ex: 80',
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _ratingController,
                        decoration: const InputDecoration(
                          labelText: 'Note (⭐) *',
                          hintText: 'Ex: 4.5',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Note requise';
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return 'Entrez un nombre valide';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                    onPressed: _isLoading ? null : _saveHotel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
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
                        : const Text('Ajouter l\'hôtel'),
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
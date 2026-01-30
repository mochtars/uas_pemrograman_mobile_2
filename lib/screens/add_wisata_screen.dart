import 'package:flutter/material.dart';
import '../models/wisata.dart';

class AddWisataScreen extends StatefulWidget {
  const AddWisataScreen({super.key});

  @override
  State<AddWisataScreen> createState() => _AddWisataScreenState();
}

class _AddWisataScreenState extends State<AddWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController(
    text: '4.5',
  );
  final TextEditingController _hargaTiketController = TextEditingController(
    text: '0',
  );
  final TextEditingController _jamBukaController = TextEditingController(
    text: '08:00 - 18:00',
  );
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _imageUrlController.dispose();
    _ratingController.dispose();
    _hargaTiketController.dispose();
    _jamBukaController.dispose();
    super.dispose();
  }

  void _addWisata() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        final newWisata = Wisata(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nama: _namaController.text.trim(),
          deskripsi: _deskripsiController.text.trim(),
          lokasi: _lokasiController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          rating: double.parse(_ratingController.text),
          hargaTiket: double.parse(_hargaTiketController.text),
          jamBuka: _jamBukaController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wisata berhasil ditambahkan!')),
        );

        Navigator.pop(context, newWisata);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Wisata'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nama Wisata
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Wisata',
                  hintText: 'Contoh: Borobudur Temple',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wisata tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Jelaskan tentang wisata ini...',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Lokasi
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Contoh: Yogyakarta, Jawa Tengah',
                  prefixIcon: const Icon(Icons.place),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL Gambar',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: const Icon(Icons.image),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL gambar tidak boleh kosong';
                  }
                  if (!value.startsWith('http')) {
                    return 'URL harus dimulai dengan http atau https';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Rating
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rating (0-5)',
                  prefixIcon: const Icon(Icons.star),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating tidak boleh kosong';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Rating harus antara 0-5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga Tiket
              TextFormField(
                controller: _hargaTiketController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Tiket (Rp)',
                  hintText: 'Contoh: 50000 atau 0 untuk gratis',
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tiket tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga tiket harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Jam Buka
              TextFormField(
                controller: _jamBukaController,
                decoration: InputDecoration(
                  labelText: 'Jam Buka',
                  hintText: 'Contoh: 08:00 - 18:00',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jam buka tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _addWisata,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Tambah Wisata',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

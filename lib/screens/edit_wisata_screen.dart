import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/wisata.dart';
import '../services/firestore_service.dart';
import '../widgets/wisata_image.dart';

class EditWisataScreen extends StatefulWidget {
  final Wisata wisata;

  const EditWisataScreen({super.key, required this.wisata});

  @override
  State<EditWisataScreen> createState() => _EditWisataScreenState();
}

class _EditWisataScreenState extends State<EditWisataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _lokasiController;
  late final TextEditingController _hargaTiketController;
  late TimeOfDay _jamBuka;
  late TimeOfDay _jamTutup;
  bool _isLoading = false;
  Uint8List? _selectedImageBytes;

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _parseTime(String str) {
    final parts = str.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: h, minute: m);
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  Future<void> _pickTime({required bool isOpen}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isOpen ? _jamBuka : _jamTutup,
    );
    if (picked != null) {
      setState(() {
        if (isOpen) {
          _jamBuka = picked;
        } else {
          _jamTutup = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.wisata.nama);
    _deskripsiController =
        TextEditingController(text: widget.wisata.deskripsi);
    _lokasiController = TextEditingController(text: widget.wisata.lokasi);
    _hargaTiketController = TextEditingController(
      text: widget.wisata.hargaTiket.toStringAsFixed(0),
    );

    // Parse "08:00 - 18:00" ke TimeOfDay
    final timeParts = widget.wisata.jamBuka.split(' - ');
    _jamBuka = timeParts.isNotEmpty
        ? _parseTime(timeParts[0].trim())
        : const TimeOfDay(hour: 8, minute: 0);
    _jamTutup = timeParts.length > 1
        ? _parseTime(timeParts[1].trim())
        : const TimeOfDay(hour: 18, minute: 0);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _hargaTiketController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  void _updateWisata() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final data = <String, dynamic>{
          'nama': _namaController.text.trim(),
          'deskripsi': _deskripsiController.text.trim(),
          'lokasi': _lokasiController.text.trim(),
          'hargaTiket': double.parse(_hargaTiketController.text),
          'jamBuka': '${_formatTime(_jamBuka)} - ${_formatTime(_jamTutup)}',
        };

        if (_selectedImageBytes != null) {
          data['imageUrl'] =
              'data:image/jpeg;base64,${base64Encode(_selectedImageBytes!)}';
        }

        await FirestoreService.updateWisata(widget.wisata.id, data);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wisata berhasil diperbarui!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui wisata: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Wisata'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _selectedImageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              WisataImage(
                                imageUrl: widget.wisata.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                color: Colors.black.withValues(alpha: 0.3),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit,
                                        size: 32, color: Colors.white),
                                    SizedBox(height: 8),
                                    Text(
                                      'Tap untuk ganti gambar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Nama Wisata
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Wisata',
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

              // Harga Tiket
              TextFormField(
                controller: _hargaTiketController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Tiket (Rp)',
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

              // Jam Buka & Tutup
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(isOpen: true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Jam Buka',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(_formatTime(_jamBuka)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('-', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(isOpen: false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Jam Tutup',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(_formatTime(_jamTutup)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateWisata,
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
                        'Simpan Perubahan',
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

import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Aplikasi Wisata Indonesia',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About
                  const Text(
                    'Tentang Aplikasi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Aplikasi Wisata Indonesia adalah platform yang memudahkan Anda untuk menjelajahi, menemukan, dan mengelola informasi tempat wisata terbaik di seluruh Indonesia. Dengan fitur lengkap, Anda dapat menambahkan wisata baru, melihat detail lengkap, dan mencari wisata favorit Anda dengan mudah.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features
                  const Text(
                    'Fitur Utama',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    icon: Icons.grid_3x3,
                    title: 'GridView Wisata',
                    description:
                        'Tampilan grid yang rapi untuk melihat semua wisata dalam satu layar',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    icon: Icons.search,
                    title: 'Pencarian Wisata',
                    description:
                        'Cari wisata berdasarkan nama atau lokasi dengan mudah',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    icon: Icons.add_circle,
                    title: 'Tambah Wisata',
                    description:
                        'Tambahkan wisata baru dengan informasi lengkap dan foto',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    icon: Icons.details,
                    title: 'Detail Wisata',
                    description:
                        'Lihat informasi lengkap tentang setiap wisata yang ada',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    icon: Icons.delete,
                    title: 'Kelola Wisata',
                    description:
                        'Hapus wisata yang tidak diperlukan dari daftar Anda',
                  ),
                  const SizedBox(height: 32),

                  // Developer Info
                  const Text(
                    'Informasi Pengembang',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          label: 'Nama Aplikasi',
                          value: 'Aplikasi Wisata Indonesia',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Versi', value: '1.0.0'),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Platform', value: 'Flutter'),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Bahasa', value: 'Dart'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Technology Stack
                  const Text(
                    'Teknologi yang Digunakan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTechItem('Flutter', 'Framework UI modern'),
                  _buildTechItem('Dart', 'Bahasa pemrograman'),
                  _buildTechItem('Material Design', 'Design system'),
                  _buildTechItem('State Management', 'setState'),
                  const SizedBox(height: 32),

                  // Contact
                  const Text(
                    'Kontak & Dukungan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.blue),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Email: support@wisataindonesia.com',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.blue),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Telepon: +62-123-456-7890',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.language, color: Colors.blue),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Website: www.wisataindonesia.com',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Tim Pengembang
                  const Text(
                    'Tim Pengembang',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Anggota Kelompok:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTeamMember('1. Beni Mochtar S'),
                        _buildTeamMember('1. Alfarisi A'),
                        _buildTeamMember('2. Ferlya Tabitha P_23552011131'),
                        _buildTeamMember('3. Noer Aziz K'),
                        _buildTeamMember('4. Susi Martini'),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Copyright © 2026 by Beni, Alfarisi, Ferlya, Aziz, Susi',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.purple,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© 2026 Aplikasi Wisata Indonesia',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All Rights Reserved',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTechItem(String tech, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 18, color: Colors.purple),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

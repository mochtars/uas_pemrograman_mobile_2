import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/wisata.dart';
import '../widgets/wisata_image.dart';
import 'detail_screen.dart';

class AllWisataScreen extends StatelessWidget {
  const AllWisataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2193b0),
                  Color(0xFF6dd5ed),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Semua Wisata',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ===== LIST WISATA =====
          Expanded(
            child: StreamBuilder<List<Wisata>>(
              stream: FirestoreService.getWisata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final wisataList = snapshot.data ?? [];

                if (wisataList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada wisata ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: wisataList.length,
                  itemBuilder: (context, index) {
                    final wisata = wisataList[index];
                    return _buildWisataItem(context, wisata);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWisataItem(BuildContext context, Wisata wisata) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(wisata: wisata),
            ),
          );
        },
        child: Row(
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: WisataImage(
                imageUrl: wisata.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wisata.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            wisata.lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (wisata.rating > 0) ...[
                          const Icon(Icons.star,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            wisata.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          wisata.formatHarga,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

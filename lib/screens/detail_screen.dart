import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wisata.dart';
import '../services/firestore_service.dart';
import '../widgets/wisata_image.dart';

class DetailScreen extends StatefulWidget {
  final Wisata wisata;

  const DetailScreen({super.key, required this.wisata});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            actions: [
              if (_uid != null)
                StreamBuilder<Set<String>>(
                  stream: FirestoreService.getFavoriteIds(_uid!),
                  builder: (context, snapshot) {
                    final isFav =
                        snapshot.data?.contains(widget.wisata.id) ?? false;
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        FirestoreService.toggleFavorite(
                            _uid!, widget.wisata.id);
                      },
                    );
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  WisataImage(
                    imageUrl: widget.wisata.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wisata.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating dari user
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<double>(
                            stream: FirestoreService.getAverageRating(
                                widget.wisata.id),
                            builder: (context, snapshot) {
                              final avg = snapshot.data ?? 0.0;
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    avg > 0 ? avg.toStringAsFixed(1) : '-',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.wisata.formatHarga,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Harga Tiket',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ===== USER RATING =====
                  if (_uid != null) _buildUserRating(),

                  const SizedBox(height: 20),

                  _buildInfoSection(
                    icon: Icons.location_on,
                    title: 'Lokasi',
                    content: widget.wisata.lokasi,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    icon: Icons.access_time,
                    title: 'Jam Buka',
                    content: widget.wisata.jamBuka,
                  ),
                  if (widget.wisata.ditambahkanOleh.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildInfoSection(
                      icon: Icons.person,
                      title: 'Ditambahkan oleh',
                      content: widget.wisata.ditambahkanOleh,
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Deskripsi',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.wisata.deskripsi,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== TOMBOL FAVORIT =====
                  if (_uid != null)
                    StreamBuilder<Set<String>>(
                      stream: FirestoreService.getFavoriteIds(_uid!),
                      builder: (context, snapshot) {
                        final isFav =
                            snapshot.data?.contains(widget.wisata.id) ??
                                false;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await FirestoreService.toggleFavorite(
                                  _uid!, widget.wisata.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFav
                                        ? 'Dihapus dari favorit'
                                        : 'Ditambahkan ke favorit'),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border),
                            label: Text(isFav
                                ? 'Hapus dari Favorit'
                                : 'Tambah ke Favorit'),
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: isFav
                                  ? Colors.red[50]
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  isFav ? Colors.red : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRating() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beri Rating',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          StreamBuilder<double?>(
            stream:
                FirestoreService.getUserRating(widget.wisata.id, _uid!),
            builder: (context, snapshot) {
              final userRating = snapshot.data ?? 0.0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1.0;
                  return GestureDetector(
                    onTap: () {
                      FirestoreService.rateWisata(
                          widget.wisata.id, _uid!, starValue);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        starValue <= userRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 36,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

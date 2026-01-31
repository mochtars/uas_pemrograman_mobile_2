import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/wisata.dart';
import '../widgets/wisata_image.dart';
import '../widgets/app_drawer.dart';
import '../screens/detail_screen.dart';
import '../screens/notification_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Wisata Favorit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                StreamBuilder<List<Wisata>>(
                  stream: FirestoreService.getWisata(),
                  builder: (context, wisataSnapshot) {
                    final currentCount =
                        wisataSnapshot.data?.length ?? 0;
                    return StreamBuilder<Map<String, dynamic>?>(
                      stream: uid != null
                          ? FirestoreService.getUserProfile(uid)
                          : const Stream.empty(),
                      builder: (context, profileSnapshot) {
                        final lastSeen = (profileSnapshot.data
                                ?['lastSeenWisataCount'] as int?) ??
                            0;
                        final hasNew = currentCount > lastSeen;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const NotificationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                ),
                                if (hasNew)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== GRID FAVORITE =====
          Expanded(
            child: uid == null
                ? const Center(child: Text('Silakan login terlebih dahulu'))
                : StreamBuilder<Set<String>>(
                    stream: FirestoreService.getFavoriteIds(uid),
                    builder: (context, favSnapshot) {
                      if (favSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final favoriteIds = favSnapshot.data ?? {};

                      if (favoriteIds.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada wisata favorit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tambahkan wisata ke favorit\ndari halaman detail',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return StreamBuilder<List<Wisata>>(
                        stream: FirestoreService.getWisata(),
                        builder: (context, wisataSnapshot) {
                          if (wisataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final allWisata = wisataSnapshot.data ?? [];
                          final favWisata = allWisata
                              .where((w) => favoriteIds.contains(w.id))
                              .toList();

                          if (favWisata.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_border,
                                      size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Belum ada wisata favorit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: GridView.builder(
                                itemCount: favWisata.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) {
                                  final wisata = favWisata[index];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              DetailScreen(wisata: wisata),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                            child: WisataImage(
                                              imageUrl: wisata.imageUrl,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  wisata.nama,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        size: 14,
                                                        color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        wisata.lokasi,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

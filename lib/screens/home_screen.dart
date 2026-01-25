import 'package:flutter/material.dart';
import '../models/wisata_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Wisata> wisataList = [];
  List<Wisata> filteredWisataList = [];

  // Data dummy wisata
  void _initializeDummyData() {
    wisataList = [
      Wisata(
        id: '1',
        nama: 'Borobudur Temple',
        deskripsi:
            'Candi Borobudur adalah salah satu situs arkeologi Buddhis terbesar di dunia.',
        lokasi: 'Magelang, Jawa Tengah',
        imageUrl: 'https://via.placeholder.com/300x200?text=Borobudur',
        rating: 4.8,
        hargaTiket: 75000,
        jamBuka: '06:00 - 17:00',
      ),
      Wisata(
        id: '2',
        nama: 'Prambanan Temple',
        deskripsi:
            'Candi Prambanan adalah kompleks kuil Hindu terbesar di Indonesia.',
        lokasi: 'Yogyakarta, Jawa Tengah',
        imageUrl: 'https://via.placeholder.com/300x200?text=Prambanan',
        rating: 4.7,
        hargaTiket: 50000,
        jamBuka: '06:00 - 18:00',
      ),
      Wisata(
        id: '3',
        nama: 'Taman Nasional Komodo',
        deskripsi:
            'Taman Nasional Komodo adalah rumah bagi komodo, spesies langka di dunia.',
        lokasi: 'Nusa Tenggara Timur',
        imageUrl: 'https://via.placeholder.com/300x200?text=Komodo',
        rating: 4.9,
        hargaTiket: 150000,
        jamBuka: '07:00 - 16:00',
      ),
      Wisata(
        id: '4',
        nama: 'Danau Toba',
        deskripsi:
            'Danau Toba adalah danau vulkanik terbesar di dunia dengan pemandangan spektakuler.',
        lokasi: 'Sumatera Utara',
        imageUrl: 'https://via.placeholder.com/300x200?text=Danau+Toba',
        rating: 4.6,
        hargaTiket: 25000,
        jamBuka: '08:00 - 18:00',
      ),
      Wisata(
        id: '5',
        nama: 'Pantai Kuta',
        deskripsi:
            'Pantai Kuta adalah salah satu pantai paling terkenal dengan pasir putih dan ombak besar.',
        lokasi: 'Bali',
        imageUrl: 'https://via.placeholder.com/300x200?text=Pantai+Kuta',
        rating: 4.5,
        hargaTiket: 0,
        jamBuka: 'Bebas',
      ),
      Wisata(
        id: '6',
        nama: 'Ubud Rice Terraces',
        deskripsi:
            'Terasering padi Ubud menawarkan pemandangan alam yang indah dan menenangkan.',
        lokasi: 'Bali',
        imageUrl: 'https://via.placeholder.com/300x200?text=Ubud+Rice',
        rating: 4.7,
        hargaTiket: 30000,
        jamBuka: '06:00 - 18:00',
      ),
    ];
    filteredWisataList = wisataList;
  }

  @override
  void initState() {
    super.initState();
    _initializeDummyData();
  }

  void _filterWisata(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWisataList = wisataList;
      } else {
        filteredWisataList = wisataList
            .where(
              (wisata) =>
                  wisata.nama.toLowerCase().contains(query.toLowerCase()) ||
                  wisata.lokasi.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _deleteWisata(String id) {
    setState(() {
      wisataList.removeWhere((wisata) => wisata.id == id);
      _filterWisata(_searchController.text);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Wisata berhasil dihapus')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Wisata'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterWisata,
              decoration: InputDecoration(
                hintText: 'Cari wisata atau lokasi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterWisata('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // GridView
          Expanded(
            child: filteredWisataList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
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
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                          ),
                      itemCount: filteredWisataList.length,
                      itemBuilder: (context, index) {
                        final wisata = filteredWisataList[index];
                        return _buildWisataCard(wisata);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_wisata').then((result) {
            if (result != null && result is Wisata) {
              setState(() {
                wisataList.add(result);
                _filterWisata(_searchController.text);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWisataCard(Wisata wisata) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail_wisata', arguments: wisata);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: Image.network(
                    wisata.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                // Rating
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.white),
                        const SizedBox(width: 2),
                        Text(
                          wisata.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    Text(
                      wisata.nama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Lokasi
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 9),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            wisata.lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Harga
                    Text(
                      wisata.hargaTiket == 0
                          ? 'Gratis'
                          : 'Rp ${wisata.hargaTiket.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    // Delete button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Wisata'),
                              content: Text(
                                'Apakah Anda yakin ingin menghapus ${wisata.nama}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteWisata(wisata.id);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, size: 12),
                        label: const Text('Hapus'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          textStyle: const TextStyle(fontSize: 9),
                        ),
                      ),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pengguna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'user@wisataindonesia.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Home
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Beranda'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                // Informasi
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Informasi Aplikasi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/info');
                  },
                ),

                // Favorit (placeholder)
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favorit'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Favorit akan segera tersedia'),
                      ),
                    );
                  },
                ),

                // Pengaturan (placeholder)
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Pengaturan akan segera tersedia'),
                      ),
                    );
                  },
                ),

                const Divider(),

                // Bantuan (placeholder)
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Bantuan'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hubungi kami di support@wisataindonesia.com'),
                      ),
                    );
                  },
                ),

                // Tentang
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tentang'),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'Aplikasi Wisata Indonesia',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 All Rights Reserved',
                      children: [
                        const Text(
                          'Aplikasi untuk menemukan dan mengelola informasi wisata di seluruh Indonesia.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Divider
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

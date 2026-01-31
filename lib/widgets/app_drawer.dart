import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../screens/about_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          // ===== HEADER PROFIL =====
          StreamBuilder<Map<String, dynamic>?>(
            stream: user != null
                ? FirestoreService.getUserProfile(user.uid)
                : const Stream.empty(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final photoData = profile?['photoUrl'] as String?;

              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: 3);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: photoData != null &&
                                photoData.startsWith('data:image')
                            ? MemoryImage(
                                base64Decode(photoData.split(',').last))
                            : null,
                        child: photoData == null
                            ? const Icon(Icons.person,
                                size: 28, color: Colors.blue)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Pengguna',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ===== MENU =====
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tentang Aplikasi'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ===== LOGOUT =====
          const Divider(),
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
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/login');
                        }
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

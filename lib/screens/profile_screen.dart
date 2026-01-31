import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import '../models/wisata.dart';
import '../widgets/app_drawer.dart';
import 'notification_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _pickAndUploadPhoto() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final base64Str = 'data:image/jpeg;base64,${base64Encode(bytes)}';

    await FirestoreService.updateUserProfile(uid, {'photoUrl': base64Str});
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    }
  }

  void _showEditProfileDialog() {
    final user = FirebaseAuth.instance.currentUser;
    final nameController =
        TextEditingController(text: user?.displayName ?? '');
    Uint8List? selectedImageBytes;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Foto picker
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 512,
                          maxHeight: 512,
                          imageQuality: 70,
                        );
                        if (picked != null) {
                          final bytes = await picked.readAsBytes();
                          setDialogState(() {
                            selectedImageBytes = bytes;
                          });
                        }
                      },
                      child: StreamBuilder<Map<String, dynamic>?>(
                        stream: user != null
                            ? FirestoreService.getUserProfile(user.uid)
                            : const Stream.empty(),
                        builder: (context, snapshot) {
                          final photoData =
                              snapshot.data?['photoUrl'] as String?;
                          ImageProvider? bgImage;

                          if (selectedImageBytes != null) {
                            bgImage = MemoryImage(selectedImageBytes!);
                          } else if (photoData != null &&
                              photoData.startsWith('data:image')) {
                            bgImage = MemoryImage(
                                base64Decode(photoData.split(',').last));
                          }

                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: bgImage,
                                child: bgImage == null
                                    ? const Icon(Icons.person,
                                        size: 40, color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap untuk ganti foto',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    if (newName.isEmpty) return;
                    try {
                      await user?.updateDisplayName(newName);
                      await user?.reload();

                      // Simpan foto jika ada yang dipilih
                      if (selectedImageBytes != null && user != null) {
                        final base64Str =
                            'data:image/jpeg;base64,${base64Encode(selectedImageBytes!)}';
                        await FirestoreService.updateUserProfile(
                            user.uid, {'photoUrl': base64Str});
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        setState(() {});
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                              content: Text('Profil berhasil diperbarui')),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  e.message ?? 'Gagal memperbarui profil')),
                        );
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ubah Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Saat Ini',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                        content: Text('Password baru tidak cocok')),
                  );
                  return;
                }

                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                        content: Text('Password minimal 6 karakter')),
                  );
                  return;
                }

                try {
                  final user = FirebaseAuth.instance.currentUser!;
                  final credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);
                  await user.updatePassword(newPassword);

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                          content: Text('Password berhasil diubah')),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  String message;
                  switch (e.code) {
                    case 'wrong-password':
                    case 'invalid-credential':
                      message = 'Password saat ini salah';
                      break;
                    case 'weak-password':
                      message = 'Password baru terlalu lemah';
                      break;
                    default:
                      message = e.message ?? 'Gagal mengubah password';
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // ===== HEADER PROFILE =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
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
            child: Column(
              children: [
                // ===== NAVBAR ROW =====
                Row(
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
                          'Profil',
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
                          stream: user != null
                              ? FirestoreService.getUserProfile(user.uid)
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
                                  color: Colors.white
                                      .withValues(alpha: 0.2),
                                  borderRadius:
                                      BorderRadius.circular(12),
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
                                          decoration:
                                              const BoxDecoration(
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
                const SizedBox(height: 20),
                StreamBuilder<Map<String, dynamic>?>(
                  stream: user != null
                      ? FirestoreService.getUserProfile(user.uid)
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    final photoData =
                        snapshot.data?['photoUrl'] as String?;

                    return GestureDetector(
                      onTap: _pickAndUploadPhoto,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white24,
                            backgroundImage: photoData != null &&
                                    photoData.startsWith('data:image')
                                ? MemoryImage(
                                    base64Decode(photoData.split(',').last))
                                : null,
                            child: photoData == null
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Color(0xFF2193b0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayName ?? 'Pengguna',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '-',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== MENU =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _menuItem(Icons.person, 'Edit Profil',
                    onTap: _showEditProfileDialog),
                _menuItem(Icons.lock, 'Ubah Password',
                    onTap: _showChangePasswordDialog),
                _menuItem(Icons.logout, 'Logout', isLogout: true,
                    onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content:
                          const Text('Apakah Anda yakin ingin logout?'),
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
                              Navigator.pushReplacementNamed(
                                  context, '/login');
                            }
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title,
      {bool isLogout = false, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

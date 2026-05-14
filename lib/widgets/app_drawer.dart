// ─────────────────────────────────────────────────────────────────────────────
// widgets/app_drawer.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as app_auth;

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _green = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? user?.phoneNumber ?? 'User';
    final uid = user?.uid ?? '';
    final photoUrl = user?.photoURL;

    return Drawer(
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_green, _lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white24,
                  child: photoUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: photoUrl,
                            width: 84,
                            height: 84,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                const CircularProgressIndicator(
                                    color: Colors.white),
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.white),
                          ),
                        )
                      : const Icon(Icons.person, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 14),

                // Display name
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                // UID (shortened)
                Text(
                  'ID : ${uid.length > 8 ? uid.substring(0, 8) : uid}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Menu Items ───────────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.grey, size: 26),
            title: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            onTap: () async {
              Navigator.pop(context); // close drawer
              final auth = context.read<app_auth.AuthProvider>();
              await auth.signOut();
            },
          ),

          const Spacer(),

          // App version footer
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'YumKart v1.0.0',
              style: TextStyle(color: Colors.black26, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

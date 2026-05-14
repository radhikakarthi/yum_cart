// ─────────────────────────────────────────────────────────────────────────────
// screens/auth/login_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as app_auth;
import 'phone_auth_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<app_auth.AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Firebase logo
              Image.network(
                'https://firebase.google.com/static/images/brand-guidelines/logo-logomark.png',
                height: 160,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_fire_department,
                  size: 100,
                  color: Color(0xFFF57C00),
                ),
              ),
              const Spacer(flex: 3),

              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Google button
              _AuthButton(
                label: 'Google',
                color: const Color(0xFF4285F4),
                icon: _GoogleIcon(),
                onTap: authProvider.isLoading
                    ? null
                    : () async {
                        authProvider.clearError();
                        await authProvider.signInWithGoogle();
                      },
              ),
              const SizedBox(height: 14),

              // Phone button
              _AuthButton(
                label: 'Phone',
                color: const Color(0xFF4CAF50),
                icon: const Icon(Icons.phone, color: Colors.white, size: 22),
                onTap: authProvider.isLoading
                    ? null
                    : () {
                        authProvider.clearError();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PhoneAuthScreen(),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 8),

              if (authProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(
                    color: Color(0xFF4285F4),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable auth button ────────────────────────────────────────────────────
class _AuthButton extends StatelessWidget {
  final String label;
  final Color color;
  final Widget icon;
  final VoidCallback? onTap;

  const _AuthButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 54,
        decoration: BoxDecoration(
          color: onTap == null ? color.withValues(alpha: 0.6) : color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Center(child: icon),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 52),
          ],
        ),
      ),
    );
  }
}

// ── Google 'G' icon ─────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

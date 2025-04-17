// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/address_list.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void handleLogout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => handleLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Berhasil Login'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressListScreen()),
                );
              },
              child: const Text("Lihat Alamat"),
            ),
          ],
        ),
      ),
    );
  }
}
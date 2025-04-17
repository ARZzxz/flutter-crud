import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authService = AuthService();
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  int step = 1;
  bool isLoading = false;

  void sendCode() async {
    setState(() => isLoading = true);
    final success = await authService.sendRegisterCode(emailController.text.trim());
    setState(() {
      isLoading = false;
      if (success) step = 2;
    });
  }

  void verifyCode() async {
    setState(() => isLoading = true);
    final success = await authService.verifyRegisterCode(
      emailController.text.trim(),
      codeController.text.trim(),
    );
    setState(() {
      isLoading = false;
      if (success) step = 3;
    });
  }

  void completeRegister() async {
    setState(() => isLoading = true);
    final success = await authService.completeRegistration(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    setState(() => isLoading = false);

    if (success) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sukses"),
          content: const Text("Registrasi berhasil, silakan login."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (step == 1)
              Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : sendCode,
                    child: const Text("Kirim Kode Verifikasi"),
                  ),
                ],
              ),
            if (step == 2)
              Column(
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Kode Verifikasi'),
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : verifyCode,
                    child: const Text("Verifikasi Kode"),
                  ),
                ],
              ),
            if (step == 3)
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Nomor HP'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isLoading ? null : completeRegister,
                    child: const Text("Register"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

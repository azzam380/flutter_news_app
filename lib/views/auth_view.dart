import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart'; // Import Controller
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/routes/app_pages.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Account Access',
            style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primaryBlue,
          iconTheme: const IconThemeData(color: AppColors.onPrimary),
          bottom: const TabBar(
            indicatorColor: AppColors.onPrimary,
            labelColor: AppColors.onPrimary,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'LOGIN', icon: Icon(Icons.login)),
              Tab(text: 'REGISTER', icon: Icon(Icons.person_add_alt_1)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LoginForm(),
            _RegisterForm(),
          ],
        ),
      ),
    );
  }
}

// --- Widget Form Login ---
class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final NewsController controller = Get.find<NewsController>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onBackground),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildTextField(label: 'Email', icon: Icons.email_outlined, controller: emailController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Password', icon: Icons.lock_outline, isPassword: true, controller: passwordController),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // LOGIKA LOGIN: Simulasikan login
              if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                  // Anggap login berhasil dan gunakan bagian email pertama sebagai username
                  final username = emailController.text.split('@').first;
                  controller.loginUser(username); 
                  Get.snackbar('Success', 'Welcome, $username! Logging you in.', snackPosition: SnackPosition.BOTTOM);
                  Get.offAllNamed(Routes.HOME); // Kembali ke beranda
              } else {
                  Get.snackbar('Error', 'Please fill in all fields.', snackPosition: SnackPosition.BOTTOM);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Get.snackbar('Forgot Password', 'Password recovery link sent.');
            },
            child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// --- Widget Form Register ---
class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final NewsController controller = Get.find<NewsController>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Create Your Account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onBackground),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildTextField(label: 'Full Name', icon: Icons.person_outline, controller: nameController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Email', icon: Icons.email_outlined, controller: emailController),
          const SizedBox(height: 16),
          _buildTextField(label: 'Password', icon: Icons.lock_outline, isPassword: true, controller: passwordController),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // LOGIKA REGISTER: Simulasikan register
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                  controller.loginUser(nameController.text);
                  Get.snackbar('Success', 'Account created! Welcome, ${nameController.text}.', snackPosition: SnackPosition.BOTTOM);
                  Get.offAllNamed(Routes.HOME); // Kembali ke beranda
              } else {
                  Get.snackbar('Error', 'Please fill in all fields.', snackPosition: SnackPosition.BOTTOM);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// --- Helper untuk TextField ---
Widget _buildTextField({required String label, required IconData icon, bool isPassword = false, required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.surfaceVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    style: const TextStyle(color: AppColors.onSurface),
  );
}
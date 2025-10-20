import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/utils/app_colors.dart';

class AccountCenterView extends GetView<NewsController> {
  const AccountCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Account Center',
          style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Akun
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: AppColors.cardShadow.withOpacity(0.1), blurRadius: 10)
                ]
              ),
              child: Column(
                children: [
                  const Icon(Icons.person_pin, size: 80, color: AppColors.primary),
                  const SizedBox(height: 10),
                  Text(
                    controller.username,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.isLoggedIn ? 'Member since 2024' : 'Guest Status',
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Text('SETTINGS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
            const Divider(color: AppColors.divider),

            // Pilihan Menu Akun
            _buildSettingTile(
              title: 'Change Username',
              icon: Icons.edit,
              onTap: () => _showUpdateDialog(context, 'Username', controller.username, (value) => controller.updateUsername(value)),
            ),
            _buildSettingTile(
              title: 'Change Password',
              icon: Icons.lock_reset,
              onTap: () => Get.snackbar('Action', 'Password reset form initiated.'),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Logout
            OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              onPressed: () {
                controller.logoutUser();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        )),
      ),
    );
  }
  
  // Helper Widget
  Widget _buildSettingTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.onSurface)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurfaceVariant),
      onTap: onTap,
    );
  }
  
  void _showUpdateDialog(BuildContext context, String field, String currentValue, Function(String) onSave) {
    final TextEditingController textController = TextEditingController(text: currentValue);
    
    Get.dialog(
      AlertDialog(
        title: Text('Update $field'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter new $field'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                onSave(textController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/utils/app_colors.dart';
// import 'package:image_picker/image_picker.dart'; // <<< Anda harus mengimport ini!

// ASUMSI: Kita tidak bisa menggunakan image_picker di lingkungan ini, 
// jadi kita simulasikan fungsinya. Anda harus mengganti simulasi ini 
// dengan kode image_picker yang sebenarnya di proyek Anda.

class AccountCenterView extends GetView<NewsController> {
  const AccountCenterView({Key? key}) : super(key: key);

  // Variabel observable untuk menyimpan jalur gambar (Simulasi)
  // Anda harus menambahkan ini ke NewsController jika Anda ingin menyimpannya permanen
  // Untuk tujuan demo ini, kita hanya menyimpannya di View (tidak persisten)
  static final RxString _profileImagePath = ''.obs; 

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
            // Header Info Akun & Foto Profil
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
                  // --- FOTO PROFIL BARU ---
                  GestureDetector(
                    onTap: () => _showImagePickerDialog(),
                    child: Stack(
                      children: [
                        Obx(() => CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.primaryContainer,
                          // LOGIC: Menampilkan gambar jika path ada, jika tidak, tampilkan ikon default
                          // if (_profileImagePath.isNotEmpty) {
                          //   return Image.file(File(_profileImagePath.value)); // ASLI: menggunakan dart:io
                          // } else {
                          //   return Icon(Icons.person, size: 50, color: AppColors.onPrimaryContainer);
                          // }
                          child: _profileImagePath.isEmpty
                              ? Icon(Icons.person, size: 50, color: AppColors.onPrimaryContainer)
                              : Text('IMG', style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 18)), // Simulasi gambar
                        )),
                        // Tombol Edit/Kamera
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- AKHIR FOTO PROFIL ---

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
            
            // --- SEKSI PENGATURAN ---
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
              onTap: () => Get.snackbar('Action', 'Password reset form initiated.', snackPosition: SnackPosition.BOTTOM),
            ),
            
            // --- SEKSI BANTUAN ---
            const SizedBox(height: 30),
            const Text('SUPPORT', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
            const Divider(color: AppColors.divider),
            
            _buildSettingTile(
              title: 'Help & Contact Us',
              icon: Icons.support_agent,
              onTap: () => _showContactDialog(context),
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
  
  // --- DIALOGS DAN LOGIC ---

  // FUNGSI INTI UNTUK MENGAMBIL GAMBAR (Simulasi image_picker)
  Future<void> _pickImage(ImageSource source) async {
    Get.back(); // Tutup bottom sheet
    
    // final picker = ImagePicker();
    // final XFile? pickedFile = await picker.pickImage(source: source); 

    // if (pickedFile != null) {
    //   _profileImagePath.value = pickedFile.path; // ASLI: Simpan path gambar
    //   Get.snackbar('Success', 'Profile picture updated!', snackPosition: SnackPosition.BOTTOM);
    // } else {
    //   Get.snackbar('Cancelled', 'Image selection cancelled.', snackPosition: SnackPosition.BOTTOM);
    // }

    // Simulasi Hasil:
    if (source == ImageSource.gallery) {
        _profileImagePath.value = 'simulated/gallery/path';
        Get.snackbar('Success', 'Profile picture updated from Gallery!', snackPosition: SnackPosition.BOTTOM);
    } else {
        _profileImagePath.value = 'simulated/camera/path';
        Get.snackbar('Success', 'Profile picture updated from Camera!', snackPosition: SnackPosition.BOTTOM);
    }
  }


  // 1. Dialog Ganti Username
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
  
  // 2. Dialog Pilih Gambar Profil (Memanggil fungsi pickImage)
  void _showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              // MEMANGGIL LOGIC PICKER DENGAN SOURCE GALLERY
              onTap: () => _pickImage(ImageSource.gallery), 
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take a Photo'),
              // MEMANGGIL LOGIC PICKER DENGAN SOURCE CAMERA
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 3. Dialog Bantuan dan Kontak
  void _showContactDialog(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Contact Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Your Message'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (subjectController.text.isNotEmpty && messageController.text.isNotEmpty) {
                Get.back();
                Get.snackbar('Success', 'Your support request has been sent!', snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar('Error', 'Please fill in both fields.', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// Enum ImageSource yang disimulasikan, karena tidak bisa import image_picker di sini.
enum ImageSource {
  camera,
  gallery,
}
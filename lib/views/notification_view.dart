import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/utils/app_colors.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of notifications
    final List<Map<String, String>> notifications = [
      {'title': 'New Category Added', 'subtitle': 'Science and Health are now available.', 'time': '5 minutes ago', 'icon': 'science'},
      {'title': 'Article Alert', 'subtitle': 'Breaking news on Technology is live!', 'time': '2 hours ago', 'icon': 'flash_on'},
      {'title': 'Premium Offer', 'subtitle': 'Get 50% off your first month subscription.', 'time': '1 day ago', 'icon': 'workspace_premium'},
      {'title': 'Regional Update', 'subtitle': 'Weather warnings for North Sumatra region.', 'time': '2 days ago', 'icon': 'location_on'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          
          IconData getIcon(String name) {
            switch (name) {
              case 'science': return Icons.science;
              case 'flash_on': return Icons.flash_on;
              case 'workspace_premium': return Icons.workspace_premium;
              case 'location_on': return Icons.location_on;
              default: return Icons.info_outline;
            }
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(getIcon(notif['icon']!), color: AppColors.onPrimaryContainer, size: 24),
            ),
            title: Text(
              notif['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            subtitle: Text(
              notif['subtitle']!,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
            ),
            trailing: Text(
              notif['time']!,
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            onTap: () {
              // Aksi saat notifikasi diklik (misalnya, navigasi ke artikel terkait)
              Get.snackbar('Alert', 'Tapped on: ${notif['title']}', snackPosition: SnackPosition.BOTTOM);
            },
          );
        },
      ),
    );
  }
}
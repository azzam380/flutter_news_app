import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  final NewsArticle article = Get.arguments as NewsArticle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            surfaceTintColor: AppColors.primary.withOpacity(0.08),
            scrolledUnderElevation: 1.0,
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
                  ? CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primary,
                        )),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.newspaper,
                        size: 50,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        const Icon(Icons.copy, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        const Text('Copy Link'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        const Icon(Icons.open_in_browser,
                            color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        const Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // --- KONTEN UTAMA ARTIKEL ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.source!.name!,
                            style: const TextStyle(
                              color: AppColors.onPrimaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (article.publishedAt != null) ...[
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  if (article.title != null) ...[
                    Text(
                      article.title!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Content
                  if (article.content != null) ...[
                    const Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Membersihkan "[+... chars]" yang sering ada di API
                      article.content!.split(RegExp(r'\[\+\d+\s*chars\]')).first,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurface,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Read More Button
                  if (article.url != null) ...[
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openInBrowser,
                          borderRadius: BorderRadius.circular(16),
                          child: const Center(
                            child: Text(
                              'READ FULL ARTICLE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // --- BAR AKSI (Like, Save) ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildActionButtons(),
            ),
          ),

          // --- KOLOM KOMENTAR ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCommentSection(),
            ),
          ),
        ],
      ),
      
      // Tombol Tulis Komentar Tetap di Bawah
      bottomNavigationBar: _buildCommentInputBar(context),
    );
  }

  // --- WIDGETS INTERAKSI ---

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Tombol Like
        TextButton.icon(
          onPressed: () => Get.snackbar('Action', 'Article Liked!', snackPosition: SnackPosition.BOTTOM),
          icon: const Icon(Icons.thumb_up_alt_outlined, color: AppColors.primary),
          label: Text('1.2K', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        // Tombol Komentar
        TextButton.icon(
          onPressed: () => Get.snackbar('Action', 'Showing Comments...', snackPosition: SnackPosition.BOTTOM),
          icon: const Icon(Icons.comment_outlined, color: AppColors.primary),
          label: Text('450', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        // Tombol Save
        TextButton.icon(
          onPressed: () => Get.snackbar('Action', 'Article Saved!', snackPosition: SnackPosition.BOTTOM),
          icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
          label: Text('Save', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments (450)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        
        // Contoh Komentar 1
        _buildCommentItem('Alan', 'Great insight! I totally agree with the author\'s point of view.', '5m ago'),
        const SizedBox(height: 8),
        
        // Contoh Komentar 2
        _buildCommentItem('JaneDoe', 'Need more details on the regional impact.', '1h ago'),
        const SizedBox(height: 8),
        
        // Tombol Lihat Lebih Banyak
        TextButton(
          onPressed: () => Get.snackbar('Action', 'Loading more comments...', snackPosition: SnackPosition.BOTTOM),
          child: const Text('View All Comments', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildCommentItem(String user, String text, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentInputBar(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  Get.snackbar('Comment Sent', 'Your comment: "${commentController.text}"', snackPosition: SnackPosition.BOTTOM);
                  commentController.clear();
                  FocusScope.of(context).unfocus(); // Sembunyikan keyboard
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  // --- FUNGSI UTILITY LAMA (Share, Copy, Open Browser) ---

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.onSurface.withOpacity(0.9),
        colorText: AppColors.surface,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.onError,
          borderRadius: 8,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }
}
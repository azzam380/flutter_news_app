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
                        child: Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primary,
                        )),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: Icon(
                        Icons.newspaper,
                        size: 50,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
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
                        Icon(Icons.copy, color: AppColors.onSurfaceVariant),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser,
                            color: AppColors.onSurfaceVariant),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.source!.name!,
                            style: TextStyle(
                              color: AppColors.onPrimaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                      if (article.publishedAt != null) ...[
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 16),

                  // Title
                  if (article.title != null) ...[
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Description
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],

                  // Content
                  if (article.content != null) ...[
                    Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      // Membersihkan "[+... chars]" yang sering ada di API
                      article.content!.split(RegExp(r'\[\+\d+\s*chars\]')).first,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurface,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Read More Button DENGAN GRADIENT
                  if (article.url != null) ...[
                    Container(
                      width: double.infinity,
                      height: 55, // Tinggi yang jelas
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: AppColors.primaryGradient, // <-- PENTING: Gradient
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openInBrowser,
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Text(
                              'READ FULL ARTICLE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimary, // Warna teks putih
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
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
          margin: EdgeInsets.all(16),
        );
      }
    }
  }
}
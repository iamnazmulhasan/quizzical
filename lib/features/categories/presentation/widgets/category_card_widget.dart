import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../domain/models/category_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  String _assetForCategory(CategoryModel cat) {
    final key = cat.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    return 'assets/images/categories/$key.png';
  }

  String _displayName(String name) {
    if (name.startsWith('Entertainment: ')) {
      return name.replaceFirst('Entertainment: ', '');
    }
    if (name.startsWith('Science: ')) {
      return name.replaceFirst('Science: ', '');
    }
    return name;
  }

  IconData _getCategoryFallbackIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('history')) return Icons.history_edu_rounded;
    if (lower.contains('art')) return Icons.palette_rounded;
    if (lower.contains('vehicle')) return Icons.directions_car_rounded;
    if (lower.contains('animal')) return Icons.pets_rounded;
    if (lower.contains('politic')) return Icons.account_balance_rounded;
    if (lower.contains('celebrities')) return Icons.star_rounded;
    if (lower.contains('comic')) return Icons.menu_book_rounded;
    if (lower.contains('gadget')) return Icons.devices_other_rounded;
    if (lower.contains('anime') || lower.contains('manga')) return Icons.tv_rounded;
    if (lower.contains('cartoon') || lower.contains('animation')) return Icons.animation_rounded;
    if (lower.contains('myth')) return Icons.fort_rounded;
    if (lower.contains('sport')) return Icons.sports_soccer_rounded;
    if (lower.contains('geo')) return Icons.public_rounded;
    if (lower.contains('book')) return Icons.menu_book_rounded;
    if (lower.contains('film') || lower.contains('movie')) return Icons.movie_rounded;
    if (lower.contains('music')) return Icons.music_note_rounded;
    if (lower.contains('computer')) return Icons.computer_rounded;
    if (lower.contains('math')) return Icons.calculate_rounded;
    return Icons.quiz_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.catBgPalette[index % AppColors.catBgPalette.length];

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    _assetForCategory(category),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getCategoryFallbackIcon(category.name),
                          size: 50,
                          color: AppColors.nextBtnBgColor.withValues(alpha: 0.8),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  _displayName(category.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.catTitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
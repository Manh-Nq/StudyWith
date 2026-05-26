import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'kid_friendly_theme.dart';

/// Lưới menu / thẻ môn học — responsive phone ↔ tablet.
abstract final class KidFriendlyMenuLayout {
  static const double maxContentWidth = 840;

  static int crossAxisCount(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 680) {
      return 3;
    }
    return 2;
  }

  /// Tỷ lệ rộng/cao thẻ: gần vuông hơn trên tablet để giảm vùng trống.
  static double cardAspectRatio(double width) {
    if (width >= 1000) {
      return 1.08;
    }
    if (width >= 680) {
      return 1.0;
    }
    return 0.92;
  }

  static double heroIconDiameter(double cardWidth, double cardHeight) {
    final double side = math.min(cardWidth, cardHeight);
    return (side * 0.42).clamp(56.0, 96.0);
  }

  static double heroGlyphSize(double heroDiameter) {
    return (heroDiameter * 0.52).clamp(28.0, 52.0);
  }

  static EdgeInsets cardPadding(double width) {
    if (width >= 680) {
      return const EdgeInsets.fromLTRB(16, 14, 16, 14);
    }
    return const EdgeInsets.fromLTRB(14, 12, 14, 12);
  }
}

/// Icon tròn lớn ở giữa thẻ menu.
class KidFriendlyHeroIconBadge extends StatelessWidget {
  const KidFriendlyHeroIconBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.diameter,
  });

  final IconData icon;
  final Color iconColor;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double glyph = KidFriendlyMenuLayout.heroGlyphSize(diameter);
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: scheme.surface,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: glyph, color: iconColor),
    );
  }
}

/// Thẻ menu: hero giữa + chữ dưới (Home, Toán, …).
class KidFriendlyHeroMenuCard extends StatelessWidget {
  const KidFriendlyHeroMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double hero = KidFriendlyMenuLayout.heroIconDiameter(
              constraints.maxWidth,
              constraints.maxHeight,
            );
            final EdgeInsets pad = KidFriendlyMenuLayout.cardPadding(
              constraints.maxWidth,
            );
            return Padding(
              padding: pad,
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: KidFriendlyHeroIconBadge(
                            icon: icon,
                            iconColor: iconColor,
                            diameter: hero,
                          ),
                        ),
                      ),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: constraints.maxWidth >= 200 ? 19 : 17,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.25,
                            ),
                      ),
                    ],
                  ),
                  if (trailing != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: trailing!,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

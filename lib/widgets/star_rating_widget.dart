import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final double starSize;
  final bool showCount;
  final Color? starColor;
  final Color? textColor;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.totalRatings = 0,
    this.starSize = 16.0,
    this.showCount = true,
    this.starColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = starColor ?? Colors.amber;
    final textColor = this.textColor ?? Colors.grey.shade600;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isHalfStar =
                rating - starIndex >= -0.5 && rating - starIndex < 0;
            final isFullStar = rating >= starIndex;

            return Icon(
              isHalfStar
                  ? Icons.star_half
                  : isFullStar
                  ? Icons.star
                  : Icons.star_border,
              size: starSize,
              color: color,
            );
          }),
        ),
        // Rating text
        if (showCount && totalRatings > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($totalRatings)',
            style: TextStyle(fontSize: starSize * 0.7, color: textColor),
          ),
        ],
      ],
    );
  }
}

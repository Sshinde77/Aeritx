import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onTrailingTap,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final Function()? onTrailingTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleLarge,
          ),
        ),
        TextButton(
          onPressed: onTrailingTap,
          child: Text(
            trailing ?? context.tr.all,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decorationColor: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

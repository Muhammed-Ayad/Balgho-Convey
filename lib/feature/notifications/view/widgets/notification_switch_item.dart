import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class NotificationSwitchItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;

  const NotificationSwitchItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeSmall,
        vertical: 2.0,
      ),
      child: SwitchListTile(
        secondary: icon != null
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isEnabled ? 0.08 : 0.03),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isEnabled ? primary : Colors.grey.shade400,
                ),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isEnabled ? null : Colors.grey.shade500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isEnabled ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              )
            : null,
        value: value,
        onChanged: isEnabled ? onChanged : null,
      ),
    );
  }
}

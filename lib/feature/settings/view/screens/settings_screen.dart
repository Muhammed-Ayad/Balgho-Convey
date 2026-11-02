import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/core/routes/routes_manager.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/theme/theme_provider.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:great_quran/feature/settings/logic/providers/azan_settings_provider.dart';
import 'package:great_quran/feature/settings/view/widgets/daylight_saving_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "الإعدادات",
      ),
      body: ListView(
        padding: const EdgeInsets.all(D.sizeMedium),
        children: const [
          SettingsHeaderWidget(),
          SizedBox(height: D.sizeLarge),
          ThemeSelectorTileWidget(),
          SizedBox(height: D.sizeSmall),
          DaylightSavingTileWidget(),
          SizedBox(height: D.sizeSmall),
          NotificationsCenterTileWidget(),
          SizedBox(height: D.sizeSmall),
          AzanSettingsTileWidget(),
          SizedBox(height: D.sizeSmall),
          WidgetsGuideTileWidget(),
          SizedBox(height: D.sizeSmall),
          ContactUsTileWidget(),
          SizedBox(height: D.sizeSmall),
          ShareAppTileWidget(),
          SizedBox(height: D.sizeSmall),
          RateAppTileWidget(),
          SizedBox(height: D.sizeXXLarge),
          AppInfoWidget(),
        ],
      ),
    );
  }
}

class SettingsHeaderWidget extends StatelessWidget {
  const SettingsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.menu_book_rounded, size: 48, color: primary),
          const SizedBox(height: D.sizeSmall),
          Text(
            context.l10n.titleAppBar,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "تطبيق إسلامي شامل للقرآن والأذكار ومواقيت الصلاة والقبلة",
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ThemeSelectorTileWidget extends ConsumerWidget {
  const ThemeSelectorTileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);

    String modeName;
    IconData icon;
    switch (currentMode) {
      case ThemeMode.light:
        modeName = "المظهر الفاتح";
        icon = Icons.light_mode_rounded;
        break;
      case ThemeMode.dark:
        modeName = "المظهر الداكن";
        icon = Icons.dark_mode_rounded;
        break;
      case ThemeMode.system:
        modeName = "تلقائي (حسب النظام)";
        icon = Icons.brightness_auto_rounded;
        break;
    }

    return SettingsActionCardWidget(
      icon: icon,
      title: "مظهر التطبيق",
      subtitle: modeName,
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) =>
              ThemeSelectionBottomSheet(selectedMode: currentMode),
        );
      },
    );
  }
}

class DaylightSavingTileWidget extends ConsumerWidget {
  const DaylightSavingTileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final azanState = ref.watch(AzanSettingsNotifier.provider);
    final currentMode =
        azanState.valueOrNull?.daylightSavingMode ?? DaylightSavingMode.auto;

    return SettingsActionCardWidget(
      icon: Icons.access_time_rounded,
      title: "التوقيت الصيفي والشتوي",
      subtitle: "الحالي: ${currentMode.title} لمواقيت الصلاة",
      onTap: () {
        DaylightSavingBottomSheet.show(context, currentMode);
      },
    );
  }
}

class NotificationsCenterTileWidget extends StatelessWidget {
  const NotificationsCenterTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.notifications_active_rounded,
      title: "مركز الإشعارات والتنبيهات",
      subtitle: "إدارة إشعارات مواقيت الصلاة، الأذكار، والسنن والمناسبات",
      onTap: () {
        context.push(Routes.notificationsSettingsRoute);
      },
    );
  }
}

class AzanSettingsTileWidget extends StatelessWidget {
  const AzanSettingsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.volume_up_rounded,
      title: "صوت ومؤذن الأذان",
      subtitle: "اختيار صوت المؤذن والاستماع لتكبيرات الأذان",
      onTap: () {
        context.push(Routes.azanSettingsRoute);
      },
    );
  }
}

class WidgetsGuideTileWidget extends StatelessWidget {
  const WidgetsGuideTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.widgets_rounded,
      title: "ودجت الشاشة الرئيسية",
      subtitle: "عرض موعد الصلاة وذكر اليوم على شاشة هاتفك",
      onTap: () {
        context.push(Routes.widgetsGuideRoute);
      },
    );
  }
}

class ThemeSelectionBottomSheet extends ConsumerWidget {
  final ThemeMode selectedMode;

  const ThemeSelectionBottomSheet({
    super.key,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(D.sizeLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "اختر مظهر التطبيق",
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: D.sizeMedium),
          ThemeOptionTile(
            title: "تلقائي (حسب النظام)",
            icon: Icons.brightness_auto_rounded,
            mode: ThemeMode.system,
            isSelected: selectedMode == ThemeMode.system,
          ),
          ThemeOptionTile(
            title: "المظهر الفاتح",
            icon: Icons.light_mode_rounded,
            mode: ThemeMode.light,
            isSelected: selectedMode == ThemeMode.light,
          ),
          ThemeOptionTile(
            title: "المظهر الداكن",
            icon: Icons.dark_mode_rounded,
            mode: ThemeMode.dark,
            isSelected: selectedMode == ThemeMode.dark,
          ),
          const SizedBox(height: D.sizeSmall),
        ],
      ),
    );
  }
}

class ThemeOptionTile extends ConsumerWidget {
  final String title;
  final IconData icon;
  final ThemeMode mode;
  final bool isSelected;

  const ThemeOptionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.mode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(D.sizeMedium),
      ),
      leading: Icon(
        icon,
        color: isSelected ? primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primary : null,
        ),
      ),
      trailing:
          isSelected ? Icon(Icons.check_circle_rounded, color: primary) : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}

class ContactUsTileWidget extends StatelessWidget {
  const ContactUsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.contact_support_rounded,
      title: context.l10n.titleContactUs,
      subtitle: "راسلنا لأي اقتراح أو استفسار",
      onTap: () {
        context.push(Routes.contactUsRoute);
      },
    );
  }
}

class ShareAppTileWidget extends StatelessWidget {
  const ShareAppTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.share_rounded,
      title: context.l10n.titleShare,
      subtitle: "شارك التطبيق ليعم الخير ولك الأجر",
      onTap: () {
        Share.share(AppEndpoints.linkPlayGoogle);
      },
    );
  }
}

class RateAppTileWidget extends StatelessWidget {
  const RateAppTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsActionCardWidget(
      icon: Icons.star_rate_rounded,
      title: context.l10n.titleReview,
      subtitle: "قيّم التطبيق على متجر التطبيقات",
      onTap: () async {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
        inAppReview.openStoreListing();
      },
    );
  }
}

class SettingsActionCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsActionCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: context.colorScheme.shadow,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeMedium),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primary, size: 22),
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "الإصدار 1.5.6\nجعلها الله في ميزان حسنات الجميع",
        style: context.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: Colors.grey.shade500,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

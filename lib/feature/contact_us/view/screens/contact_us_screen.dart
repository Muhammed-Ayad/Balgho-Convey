import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/constants.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/network/endpoints.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: const CustomAppBar(
        title: "تواصل معنا",
      ),
      body: ListView(
        padding: const EdgeInsets.all(D.sizeMedium),
        children: const [
          ContactHeaderCard(),
          SizedBox(height: D.sizeMedium),
          ContactEmailActionCard(),
          SizedBox(height: D.sizeMedium),
          ContactAppInfoCard(),
          SizedBox(height: D.sizeLarge),
        ],
      ),
    );
  }
}

class ContactHeaderCard extends StatelessWidget {
  const ContactHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.contact_support_rounded,
              size: 40,
              color: primary,
            ),
          ),
          const SizedBox(height: D.sizeMedium),
          const Text(
            "مرحباً بك في تطبيق بلغوا 🌿",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: D.sizeSmall),
          Text(
            "يسعدنا دائماً استقبال آرائكم ومقترحاتكم الكريمة، أو الإبلاغ عن أي ملاحظات؛ لتطوير التطبيق وخدمة كتاب الله عز وجل وسنة نبيه ﷺ.",
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: context.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ContactEmailActionCard extends StatelessWidget {
  const ContactEmailActionCard({super.key});

  static const String developerEmail = "mohamedayaddev@gmail.com";

  Future<void> _launchEmail(BuildContext context) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: developerEmail,
      query: 'subject=${Uri.encodeComponent("تطبيق بلغوا - مقترح / استفسار")}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(Uri.parse(AppEndpoints.mailTo));
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("تعذر فتح تطبيق البريد تلقائياً، يمكنك نسخ البريد أدناه"),
        ),
      );
    }
  }

  Future<void> _copyEmail(BuildContext context) async {
    await FlutterClipboard.copy(developerEmail);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: Constants.milliseconds),
        content: Text("تم نسخ البريد الإلكتروني بنجاح 📋"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(D.sizeLarge),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.mail_rounded,
                  color: primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: D.sizeMedium),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تواصل معنا عبر الإيميل",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "المراسلة المباشرة مع مطور التطبيق",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeLarge),

          // Display the email in a highlighted selectable box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.alternate_email_rounded,
                  color: Colors.grey,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    developerEmail,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: D.sizeLarge),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text(
                      "إرسال رسالة الآن",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () => _launchEmail(context),
                  ),
                ),
              ),
              const SizedBox(width: D.sizeSmall),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: BorderSide(
                        color: primary.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text(
                      "نسخ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    onPressed: () => _copyEmail(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactAppInfoCard extends StatelessWidget {
  const ContactAppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(D.sizeMedium),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 16,
            color: Colors.red.shade400,
          ),
          const SizedBox(width: 8),
          const Text(
            "تطبيق بلغوا — صدقة جارية ولوالدينا ولكم ولجميع المسلمين",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_asset.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_theme.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final colors = context.appColors;
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in Name, Email and Message.',
            style: TextStyle(color: colors.text),
          ),
          backgroundColor: colors.cardBg,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    setState(() => _sending = true);
    final uri = Uri(
      scheme: 'mailto',
      path: AppStrings.mailtoRecipient,
      queryParameters: {
        'subject': _subjectCtrl.text.trim().isNotEmpty
            ? _subjectCtrl.text.trim()
            : 'Portfolio Contact',
        'body':
            'Name: ${_nameCtrl.text.trim()}\nReply-to: ${_emailCtrl.text.trim()}\n\n${_messageCtrl.text.trim()}',
      },
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    setState(() => _sending = false);
  }

  Future<void> _downloadResume() async {
    try {
      await launchUrl(
        Uri.parse(AppAssets.resume),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: isMobile ? 32 : 52,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              children: [
                TextSpan(
                    text: "Let's Work ", style: TextStyle(color: colors.text)),
                TextSpan(
                    text: 'Together', style: TextStyle(color: colors.accent)),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 12),
          Text(
            "Have a project in mind? I'm always open to discussing new opportunities,\ncreative ideas, or just having a chat about tech.",
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14,
              height: 1.65,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo(colors),
                    const SizedBox(height: 40),
                    _buildForm(colors, isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildContactInfo(colors)),
                    const SizedBox(width: 48),
                    Expanded(flex: 6, child: _buildForm(colors, isMobile)),
                  ],
                ),
          const SizedBox(height: 80),
          _buildResumeDownload(colors, isMobile),
          const SizedBox(height: 64),
          Container(height: 1, color: colors.border),
          const SizedBox(height: 28),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSocialLinks(colors),
                    const SizedBox(height: 24),
                    _buildFooterBottom(colors),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSocialLinks(colors),
                    _buildFooterBottom(colors),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(AppColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contactCard(
          colors: colors,
          icon: Icons.email_rounded,
          iconColor: const Color(0xFF3B82F6),
          label: 'Email',
          value: AppStrings.contactEmail,
          onTap: () => launchUrl(Uri.parse('mailto:${AppStrings.contactEmail}'),
              mode: LaunchMode.externalApplication),
        ),
        const SizedBox(height: 16),
        _contactCard(
          colors: colors,
          icon: Icons.phone_rounded,
          iconColor: const Color(0xFF06B6D4),
          label: 'Phone',
          value: AppStrings.phoneNumber,
          onTap: () => launchUrl(Uri.parse('tel:${AppStrings.phoneNumber}'),
              mode: LaunchMode.externalApplication),
        ),
        const SizedBox(height: 16),
        _contactCard(
          colors: colors,
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFFD946EF),
          label: 'Location',
          value: AppStrings.location,
          onTap: null,
        ),
      ],
    );
  }

  Widget _contactCard({
    required AppColorScheme colors,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.14),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: colors.textMuted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AppColorScheme colors, bool isMobile) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
    );

    final fieldTextStyle = TextStyle(color: colors.text, fontSize: 14);
    final labelTextStyle = TextStyle(
      color: colors.textMuted,
      fontSize: 12,
      letterSpacing: 0.3,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: labelTextStyle),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameCtrl,
                    style: fieldTextStyle,
                    decoration: inputDecoration.copyWith(hintText: 'John Doe'),
                  ),
                  const SizedBox(height: 16),
                  Text('Email', style: labelTextStyle),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailCtrl,
                    style: fieldTextStyle,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        inputDecoration.copyWith(hintText: 'john@example.com'),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name', style: labelTextStyle),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nameCtrl,
                          style: fieldTextStyle,
                          decoration:
                              inputDecoration.copyWith(hintText: 'John Doe'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email', style: labelTextStyle),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emailCtrl,
                          style: fieldTextStyle,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration.copyWith(
                              hintText: 'john@example.com'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 16),
        Text('Subject', style: labelTextStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _subjectCtrl,
          style: fieldTextStyle,
          decoration: inputDecoration.copyWith(hintText: 'Project Inquiry'),
        ),
        const SizedBox(height: 16),
        Text('Message', style: labelTextStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _messageCtrl,
          style: fieldTextStyle,
          maxLines: 5,
          decoration: inputDecoration.copyWith(
              hintText: 'Tell me about your project...'),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _sending ? null : _sendMessage,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.background],
              ),
            ),
            child: Center(
              child: _sending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Send Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResumeDownload(AppColorScheme colors, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.accent.withValues(alpha: 0.06),
            colors.cardBg,
          ],
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download My Resume',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get a detailed look at my experience, skills, and projects.',
                  style: TextStyle(
                      color: colors.textMuted, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  // onTap: _downloadResume,
                  child: _resumeButton(colors),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Download My Resume',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get a detailed look at my experience, skills, and projects.',
                      style: TextStyle(
                          color: colors.textMuted, fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  // onTap: _downloadResume,
                  child: _resumeButton(colors),
                ),
              ],
            ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _resumeButton(AppColorScheme colors) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colors.accent.withValues(alpha: 0.1),
          border: Border.all(color: colors.accent, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, color: colors.accent, size: 20),
            const SizedBox(width: 10),
            Text(
              'Download Resume',
              style: TextStyle(
                color: colors.accent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(AppColorScheme colors) {
    return Wrap(
      spacing: 0,
      runSpacing: 4,
      children: [
        _socialRow(
            colors, 'GitHub', AppStrings.githubUrl, AppAssets.githubIcon),
        _socialRow(
            colors, 'LinkedIn', AppStrings.linkedInUrl, AppAssets.linkedinIcon),
        _socialRow(
            colors, 'Facebook', AppStrings.facebookUrl, AppAssets.facebookIcon),
        _socialRow(colors, 'Instagram', AppStrings.instagramUrl,
            AppAssets.instagramIcon),
      ],
    );
  }

  Widget _socialRow(
      AppColorScheme colors, String label, String url, String iconAsset) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, right: 24),
      child: GestureDetector(
        onTap: () =>
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, height: 18, width: 18, color: colors.text),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: colors.text, fontSize: 13)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_outward, color: colors.accent, size: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterBottom(AppColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Designed and Developed by ${AppStrings.ownerName}',
          style: TextStyle(color: colors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2026',
          style: TextStyle(color: colors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}

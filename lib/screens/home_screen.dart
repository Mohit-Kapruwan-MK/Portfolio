import 'package:flutter/material.dart';
import '../widgets/common/navbar.dart';
import '../widgets/common/animated_grid_bg.dart';
import '../widgets/sections/landing_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/services_section.dart';
import '../widgets/sections/technical_expertise_section.dart';
import '../widgets/sections/what_i_do_section.dart';
import '../widgets/sections/career_section.dart';
import '../widgets/sections/work_section.dart';
import '../widgets/sections/techstack_section.dart';
import '../widgets/sections/flutter_showcase_section.dart';
import '../widgets/sections/contact_section.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Stack(
        children: [
          AnimatedGridBackground(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LandingSection(),
                  AboutSection(key: _aboutKey),
                  const ServicesSection(),
                  const TechnicalExpertiseSection(),
                  const WhatIDoSection(),
                  const CareerSection(),
                  WorkSection(key: _workKey),
                  const TechStackSection(),
                  const FlutterShowcaseSection(),
                  ContactSection(key: _contactKey),
                ],
              ),
            ),
          ),
          Navbar(
            onAbout: () => _scrollTo(_aboutKey),
            onWork: () => _scrollTo(_workKey),
            onContact: () => _scrollTo(_contactKey),
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }
}

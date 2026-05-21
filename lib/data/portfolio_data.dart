import 'package:flutter/material.dart';

class CareerItem {
  final String role;
  final String company;
  final String period;
  final String description;

  const CareerItem({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
  });
}

class Project {
  final String title;
  final String category;
  final String tools;
  final String link;
  final Color tintColor;

  const Project({
    required this.title,
    required this.category,
    required this.tools,
    required this.link,
    required this.tintColor,
  });
}

class WhatIDoItem {
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;

  const WhatIDoItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
  });
}

const List<CareerItem> careerItems = [
  CareerItem(
    role: 'Software Developer',
    company: 'Live Informatics Deftsoft PVT LTD · Mohali',
    period: 'July 2023 - Now',
    description:
        'Experienced Software Engineer specializing in hybrid app development for mobile and web platforms. Currently contributing my skills and expertise as a Flutter Developer at Deftsoft since July 2023. Passionate about creating seamless and engaging user experiences through innovative technology solutions. Excited to collaborate with talented teams and drive the evolution of modern application development.',
  ),
  CareerItem(
    role: 'Customer Service Associate',
    company: 'iEnergizer · Noida',
    period: 'June 2022 - December 2022',
    description:
        'As a Customer Support Executive at Pine Labs, I have had a great 6-month experience. I have had the opportunity to interact with customers from all over the India and help them with their queries related to their Pine Labs account and payment transactions. I have also had the opportunity to provide technical support to customers when needed. I have learned how to effectively communicate and resolve customer issues in a timely manner. Furthermore, I have gained an understanding of the technical aspects of the Pine Labs platform, which has enabled me to provide better customer service. Overall, it has been an enriching experience that has allowed me to strengthen my customer service skills.',
  ),
];

const List<Project> projects = [
  Project(
    title: 'Dealsquawk',
    tintColor: Color(0xFF5EEAD4),
    category:
        'Social Community App where users create nests, share posts, interact with communities, and chat in real-time.',
    tools:
        'Flutter, Firebase Auth, Cloud Firestore, Real-time Chat, Push Notifications, REST APIs, State Management',
    link: 'https://apps.apple.com/us/app/dealsquawk/id6746202322',
  ),
  Project(
    title: 'YezidiLink',
    tintColor: Color(0xFFFF6B9D),
    category:
        'Dating Mobile Application with swipe matching, profile discovery, chat system, and user connection features similar to Tinder.',
    tools:
        'Flutter, Firebase, Real-time Database, Match Algorithm, Chat Integration, Push Notifications, REST APIs',
    link:
        'https://play.google.com/store/apps/details?id=com.app.yezidilink&pcampaignid=web_share',
  ),
  Project(
    title: 'Modyaf',
    tintColor: Color(0xFF6366F1),
    category:
        'Airbnb-style booking platform for rental properties with smart room access and reservation management.',
    tools:
        'Flutter, Firebase, REST APIs, Google Maps, Payment Gateway, TT Lock SDK, Booking System, Push Notifications',
    link:
        'https://play.google.com/store/apps/details?id=com.modyaf.host&pcampaignid=web_share',
  ),
  Project(
    title: 'SuperNotes AI',
    tintColor: Color(0xFFF59E0B),
    category:
        'AI-powered note-taking application with audio-to-text conversion, local storage, and drag & drop note organization.',
    tools:
        'Flutter, Local Database, Speech-to-Text, AI Processing, Offline Storage, Drag & Drop UI, Provider, File Handling',
    link:
        'https://play.google.com/store/apps/details?id=com.supernotes.app&pcampaignid=web_share',
  ),
];

const List<WhatIDoItem> whatIDoItems = [
  WhatIDoItem(
    title: 'FLUTTER DEVELOPMENT',
    subtitle: 'Cross-Platform Mobile App Solutions',
    description:
        'Flutter developer with 3 years of experience building high-performance, responsive, and user-friendly mobile applications for Android and iOS.',
    tags: [
      'Flutter',
      'Dart',
      'Cross-platform apps',
      'Responsive UI',
      'Custom widgets',
      'App performance',
    ],
  ),
  WhatIDoItem(
    title: 'BUILD & DEPLOY',
    subtitle: 'Scalable Apps in Production',
    description:
        'I develop complete mobile solutions with clean architecture, API integration, state management, and production-ready deployment for real-world users.',
    tags: [
      'REST APIs',
      'Firebase',
      'Provider',
      'Riverpod',
      'SQLite',
      'Git',
      'Play Store & App Store',
    ],
  ),
];

const List<String> techStack = [
  'React',
  'Next.js',
  'Node.js',
  'Express',
  'MongoDB',
  'MySQL',
  'TypeScript',
  'JavaScript',
];

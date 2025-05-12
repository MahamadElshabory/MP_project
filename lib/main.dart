// lib/main.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Firebase core & auth
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// sqflite for desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/class_schedule_screen.dart';
import 'screens/study_group_screen.dart';
import 'screens/event_feed_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/create_announcement_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // On desktop, use ffi for SQLite
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Firebase on all platforms
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Always sign out on startup so LoginScreen appears
  await FirebaseAuth.instance.signOut();

  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

/// Decides whether to show LoginScreen or MainNavigation based on auth state,
/// and computes teacher vs. student role by email domain.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        if (user == null || user.isAnonymous) {
          return const LoginScreen();
        }

        // Determine role by email domain
        final email = user.email ?? '';
        final domain = email.contains('@') ? email.split('@').last : '';
        final isTeacher = domain == 'gmail.com';

        return MainNavigation(isTeacher: isTeacher);
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isTeacher;
  const MainNavigation({Key? key, required this.isTeacher}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(isTeacher: widget.isTeacher),
      ClassScheduleScreen(isTeacher: widget.isTeacher),
      const StudyGroupScreen(),
      EventFeedScreen(isTeacher: widget.isTeacher),
      const NotesScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

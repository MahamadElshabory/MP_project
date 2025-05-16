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

// Our Firebase-backed service
import 'services/firebase_service.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/class_schedule_screen.dart';
import 'screens/study_group_screen.dart';
import 'screens/event_feed_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/profile_screen.dart';

// === Cinematic Dark Palette ===
const kBgColor     = Color(0xFF0B132B); // Ink-blue
const kCardColor   = Color(0xFF1C2541); // Deep slate
const kAccentColor = Color(0xFFFF4081); // Neon magenta

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signOut();

  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: kBgColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kCardColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle:
          const TextStyle(color: Colors.white, fontSize: 20),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kCardColor,
          selectedItemColor: kAccentColor,
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kAccentColor,
          foregroundColor: Colors.black,
        ),
        cardColor: kCardColor,
        colorScheme: ColorScheme.dark(
          primary: kAccentColor,
          secondary: kAccentColor,
          background: kBgColor,
          surface: kCardColor,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.active) {
          return const Scaffold(
            backgroundColor: kBgColor,
            body: Center(
              child: CircularProgressIndicator(color: kAccentColor),
            ),
          );
        }
        final user = snap.data;
        if (user == null || user.isAnonymous) {
          return const LoginScreen();
        }

        final email = user.email ?? '';
        final domain =
        email.contains('@') ? email.split('@').last : '';
        final isTeacher = domain == 'gmail.com';
        return MainNavigation(isTeacher: isTeacher);
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isTeacher;
  const MainNavigation({Key? key, required this.isTeacher})
      : super(key: key);

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),

      // FAB removed here to prevent it showing on every tab

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Classes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
              icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

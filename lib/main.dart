import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// Firebase core
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// sqflite for desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'screens/home_screen.dart';
import 'screens/class_schedule_screen.dart';
import 'screens/study_group_screen.dart';
import 'screens/event_feed_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/profile_screen.dart';


Future<void> main() async {
  // Ensure Flutter binding initialized
  WidgetsFlutterBinding.ensureInitialized();

  // On desktop, initialize the FFI sqlite factory
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _screens = const [
    HomeScreen(),
    ClassScheduleScreen(),
    StudyGroupScreen(),
    EventFeedScreen(),
    NotesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),     label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.group),    label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.event),    label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.note),     label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.person),   label: 'Profile'),
        ],
      ),
    );
  }
}

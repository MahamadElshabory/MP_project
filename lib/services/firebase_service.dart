// lib/services/firebase_service.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/announcement_model.dart';
import '../models/event_model.dart';
import '../models/group_note_model.dart';     // <— here!
import '../models/assignment_model.dart';
import '../models/session_model.dart';
import '../models/class_model.dart';
import '../db/database_helper.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final _annRef = FirebaseDatabase.instance.ref('announcements');
  final _evtRef = FirebaseDatabase.instance.ref('events');
  final _grpRef = FirebaseDatabase.instance.ref('study_groups');
  final _clsRef = FirebaseDatabase.instance.ref('classes');

  // ─── Announcements ────────────────────────────────────────────────────────────

  Stream<List<AnnouncementModel>> announcementsStream() {
    return _annRef.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <AnnouncementModel>[];
      data.forEach((key, value) {
        final map = Map<String, dynamic>.from(value as Map);
        list.add(AnnouncementModel.fromMap(key as String, map));
      });
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }

  Future<void> postAnnouncement(AnnouncementModel a) async {
    final key = _annRef.push().key!;
    await _annRef.child(key).set(a.toMap());
  }

  // ─── Events ───────────────────────────────────────────────────────────────────

  Stream<List<EventModel>> eventsStream() {
    return _evtRef.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <EventModel>[];
      data.forEach((key, value) {
        list.add(EventModel.fromFirebase(
          key as String,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return list;
    });
  }

  Future<void> postEvent(EventModel e) async {
    final key = _evtRef.push().key!;
    await _evtRef.child(key).set(e.toFirebase());
    // also mirror locally
    final local = e.copyWith(firebaseKey: key);
    await DatabaseHelper.instance.createEvent(local);
  }

  Future<void> updateEventRSVP(String key, bool isRSVP) {
    return _evtRef.child(key).update({'isRSVP': isRSVP ? 1 : 0});
  }

  // ─── Study Groups ─────────────────────────────────────────────────────────────

  Stream<List<EventModel>> groupsStream() {
    return _grpRef.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <EventModel>[];
      data.forEach((key, value) {
        list.add(EventModel.fromFirebase(
          key as String,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return list;
    });
  }

  Future<void> postGroup(EventModel g) async {
    final key = _grpRef.push().key!;
    await _grpRef.child(key).set(g.toFirebase());
    // mirror locally too
    final local = g.copyWith(firebaseKey: key);
    await DatabaseHelper.instance.createEvent(local);
  }

  Future<void> updateGroupRSVP(String key, bool isRSVP) {
    return _grpRef.child(key).update({'isRSVP': isRSVP ? 1 : 0});
  }

  // ─── Collaborative Notes ────────────────────────────────────────────────────

  Stream<List<GroupNoteModel>> groupNotesStream(String groupKey) {
    final notesRef = _grpRef.child(groupKey).child('notes');
    return notesRef.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <GroupNoteModel>[];
      data.forEach((k, v) {
        final map = Map<String, dynamic>.from(v as Map);
        list.add(GroupNoteModel.fromMap(k as String, map));
      });
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }

  Future<void> postGroupNote(String groupKey, String content) async {
    final notesRef = _grpRef.child(groupKey).child('notes');
    final key = notesRef.push().key!;
    final author = FirebaseAuth.instance.currentUser?.uid ?? '';
    await notesRef.child(key).set({
      'authorUid': author,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ─── Assignments ─────────────────────────────────────────────────────────────

  Stream<List<AssignmentModel>> groupAssignmentsStream(String groupKey) {
    final ref = _grpRef.child(groupKey).child('assignments');
    return ref.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <AssignmentModel>[];
      data.forEach((k, v) {
        list.add(AssignmentModel.fromMap(
          k as String,
          Map<String, dynamic>.from(v as Map),
        ));
      });
      list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return list;
    });
  }

  Future<void> postGroupAssignment(String groupKey, AssignmentModel a) async {
    final ref = _grpRef.child(groupKey).child('assignments');
    final key = ref.push().key!;
    await ref.child(key).set(a.toMap());
  }

  // ─── Study Sessions ─────────────────────────────────────────────────────────

  Stream<List<SessionModel>> groupSessionsStream(String groupKey) {
    final ref = _grpRef.child(groupKey).child('sessions');
    return ref.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <SessionModel>[];
      data.forEach((k, v) {
        list.add(SessionModel.fromMap(
          k as String,
          Map<String, dynamic>.from(v as Map),
        ));
      });
      list.sort((a, b) => a.sessionTime.compareTo(b.sessionTime));
      return list;
    });
  }

  Future<void> postGroupSession(String groupKey, SessionModel s) async {
    final ref = _grpRef.child(groupKey).child('sessions');
    final key = ref.push().key!;
    await ref.child(key).set(s.toMap());
  }

  // ─── Classes ────────────────────────────────────────────────────────────────

  /// Stream of all classes (real-time)
  Stream<List<ClassModel>> classesStream() {
    return _clsRef.onValue.map((e) {
      final data = e.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final list = <ClassModel>[];
      data.forEach((key, value) {
        list.add(ClassModel.fromFirebase(
          key as String,
          Map<String, dynamic>.from(value as Map),
        ));
      });
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return list;
    });
  }

  /// Only teachers call this to add a class
  Future<void> postClass(ClassModel c) async {
    final key = _clsRef.push().key!;
    // 1) write to Firebase
    await _clsRef.child(key).set(c.toMap());
    // 2) mirror locally into SQLite
    final local = c.copyWith(firebaseKey: key, key: key);
    await DatabaseHelper.instance.createClass(local);
  }
}

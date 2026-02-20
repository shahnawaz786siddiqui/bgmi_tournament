import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserCredential?> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
    String? phoneNumber,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'isAdmin': false,
        'walletBalance': 0.0,
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return data?['isAdmin'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Add tournament (Admin only)
  Future<void> addTournament({
    required String title,
    required String gameType,
    required double prizePool,
    required double perKill,
    required int maxParticipants,
    required DateTime startTime,
    String? gameId,
    String? gamePassword,
  }) async {
    try {
      await _firestore.collection('tournaments').add({
        'title': title,
        'gameType': gameType,
        'prizePool': prizePool,
        'perKill': perKill,
        'maxParticipants': maxParticipants,
        'currentParticipants': 0,
        'startTime': Timestamp.fromDate(startTime),
        'gameId': gameId ?? '',
        'gamePassword': gamePassword ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'upcoming', // upcoming, live, completed
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get all tournaments
  Stream<QuerySnapshot> getTournaments() {
    return _firestore
        .collection('tournaments')
        .orderBy('startTime', descending: false)
        .snapshots();
  }

  // Join tournament
  Future<void> joinTournament(String tournamentId, String userId) async {
    try {
      DocumentReference tournamentRef = _firestore.collection('tournaments').doc(tournamentId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot tournamentDoc = await transaction.get(tournamentRef);
        
        if (!tournamentDoc.exists) {
          throw Exception('Tournament not found');
        }

        Map<String, dynamic> data = tournamentDoc.data() as Map<String, dynamic>;
        int currentParticipants = data['currentParticipants'] ?? 0;
        int maxParticipants = data['maxParticipants'] ?? 0;

        if (currentParticipants >= maxParticipants) {
          throw Exception('Tournament is full');
        }

        // Check if user already joined
        DocumentReference participantRef = _firestore
            .collection('tournaments')
            .doc(tournamentId)
            .collection('participants')
            .doc(userId);

        DocumentSnapshot participantDoc = await transaction.get(participantRef);
        if (participantDoc.exists) {
          throw Exception('Already joined this tournament');
        }

        // Add participant
        transaction.set(participantRef, {
          'userId': userId,
          'joinedAt': FieldValue.serverTimestamp(),
        });

        // Update participant count
        transaction.update(tournamentRef, {
          'currentParticipants': FieldValue.increment(1),
        });
      });
    } catch (e) {
      rethrow;
    }
  }
}


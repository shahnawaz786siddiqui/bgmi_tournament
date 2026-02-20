import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'join_match_screen.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  String _formatTimeRemaining(DateTime startTime) {
    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative) {
      return 'Started';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    return '$days Days, $hours Hr, $minutes Min';
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF192131),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('How to Work ?', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF192131),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getTournaments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No tournaments available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final title = data['title'] ?? 'Tournament';
              final prizePool = data['prizePool'] ?? 0.0;
              final perKill = data['perKill'] ?? 0.0;
              final maxParticipants = data['maxParticipants'] ?? 0;
              final currentParticipants = data['currentParticipants'] ?? 0;
              final startTime = (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now();
              final gameId = data['gameId'] ?? '';
              final gamePassword = data['gamePassword'] ?? '';
              final spotsLeft = maxParticipants - currentParticipants;

              return _buildTournamentCard(
                context,
                doc.id,
                title,
                prizePool,
                perKill,
                maxParticipants,
                currentParticipants,
                startTime,
                gameId,
                gamePassword,
                spotsLeft,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTournamentCard(
    BuildContext context,
    String tournamentId,
    String title,
    double prizePool,
    double perKill,
    int maxParticipants,
    int currentParticipants,
    DateTime startTime,
    String gameId,
    String gamePassword,
    int spotsLeft,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF222B3B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _formatTimeRemaining(startTime),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prize Pool: ₹${prizePool.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green.shade400, fontSize: 14),
                  ),
                  Text(
                    'Per Kill: ₹${perKill.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green.shade400, fontSize: 14),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinMatchScreen(
                        tournamentId: tournamentId,
                        tournamentTitle: title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('Free Join', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '($currentParticipants/$maxParticipants ${spotsLeft > 0 ? "Only $spotsLeft Spots Left" : "Full"})',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _actionButton('Gameplay Live', Colors.red, () {}),
              _actionButton(
                'Id & Password',
                const Color(0xFF3B4455),
                () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF222B3B),
                      title: const Text('Game Details', style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (gameId.isNotEmpty)
                            Text('Game ID: $gameId', style: const TextStyle(color: Colors.white)),
                          if (gamePassword.isNotEmpty)
                            Text('Password: $gamePassword', style: const TextStyle(color: Colors.white)),
                          if (gameId.isEmpty && gamePassword.isEmpty)
                            const Text('No game details available', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/firebase_service.dart';

class JoinMatchScreen extends StatefulWidget {
  final String tournamentId;
  final String tournamentTitle;
  
  const JoinMatchScreen({
    super.key,
    required this.tournamentId,
    required this.tournamentTitle,
  });

  @override
  State<JoinMatchScreen> createState() => _JoinMatchScreenState();
}

class _JoinMatchScreenState extends State<JoinMatchScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _gameNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _gameNameController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (_gameNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your game name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _firebaseService.currentUser;
      if (user != null) {
        await _firebaseService.joinTournament(widget.tournamentId, user.uid);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined tournament!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF192131),
      appBar: AppBar(
        title: Text(widget.tournamentTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF192131),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildJoinForm(),
            const SizedBox(height: 25),
            const Text(
              'Match Rules',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            _buildRulesList(),
            const SizedBox(height: 25),
            const Text(
              'Complaint System',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            _buildComplaintSystem(),
            const SizedBox(height: 20),
            const Center(
              child: Text('⚠️ Thanks for joining!', style: TextStyle(color: Colors.yellow, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildJoinForm() {
    return Column(
      children: [
        TextField(
          controller: _gameNameController,
          decoration: InputDecoration(
            hintText: 'Enter Your Game Name > 1',
            hintStyle: const TextStyle(color: Colors.white70),
            fillColor: const Color(0xFFED3B6A),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _handleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED3B6A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Join Now', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
      ],
    );
  }

  Widget _buildRulesList() {
    final rules = [
      'Hamesa Notification Ko On Rakhe Jise Se Aapko Sabhi Updates And Room ID Pass Update Notification Time Par Mil Sake',
      'Price Pool Hamesa Winner Players Ko Diya Jayega Price Pool Kabhi Bhi I Player Ko Nahi Diya Jata Hai',
      'Note - Kisko Kitna Amount Milega Ye Dekhne Ke Liye Price Pool Par Click Kare',
      'Aapko Tournament Ka Room ID & Pass Match Start Hone Se 10-15 Minutes Pahle Mil Jayega App Ke Andar',
      'Unregistered Friend Invite -> Ban',
      'Game Name should match join name',
      'Room full -> Join 18 mins early next time',
      'Only 20+ Level ID Players allowed',
      'CS & BR Headshot Rate below 70% required',
      'Only Mobile Devices (No Emulators)',
      'No hacks, aimbots, mods, glitches, or teaming',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rules.map((rule) => _buildRuleItem(rule)).toList(),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('>', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintSystem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComplaintDetail(
          Icons.error_outline,
          'Contact within 24 hrs for any issues',
          Colors.red,
        ),
        _buildComplaintDetail(
          Icons.call,
          'WhatsApp: +91 7505704545',
          Colors.green,
        ),
        _buildComplaintDetail(
          Icons.email_outlined,
          'support@ffzonefreefireesports.in',
          Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Late complaints not accepted',
            style: TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintDetail(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'tournament_screen.dart'; // We will create this file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildBanner(),
            const SizedBox(height: 20),
            _buildEsportsGamesSection(context), // Added context to navigate
            const SizedBox(height: 20),
            _buildMyMatchesButton(),
            const SizedBox(height: 30),
            _buildFollowUsSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF192131),
      title: const Row(
        children: <Widget>[
          // Placeholder for GT Battle Logo
          Text(
            'GT Battle',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.emoji_events_outlined, color: Colors.yellow),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.yellow, size: 18),
              SizedBox(width: 4),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFA9A3E), // Orange/Gold background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Placeholder for the card image
          Container(
            width: 150,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('Tournament Card')),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Click Banner',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "Join WhatsApp Channel Guy's 😌",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEsportsGamesSection(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'ESports Games',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        // Gaming Tournament Card - Tap to navigate to the Tournament Screen
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TournamentScreen()),
            );
          },
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'FREE TOURNAMENTS\n(Click to view matches)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyMatchesButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFED3B6A), // Pink/Red Button
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'My Matches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Follow us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildSocialButton(Icons.facebook, 'Join **Facebook**', Colors.blue, 'Follow'),
        _buildSocialButton(Icons.camera_alt_outlined, 'Join **Instagram**', Colors.pink, 'Follow'),
        _buildSocialButton(Icons.call, 'Join **WhatsApp**', Colors.green, 'Follow'),
        _buildSocialButton(Icons.send, 'Join **Telegram**', Colors.lightBlue, 'Follow'),
        _buildSocialButton(Icons.play_circle_outline, 'Join **YouTube**', Colors.red, 'Follow'),
        _buildSocialButton(Icons.star, 'Rate us on play store', Colors.yellow, 'Rate us', isRateButton: true),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String text, Color iconColor, String buttonText, {bool isRateButton = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF222B3B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text.replaceAll('**', ''), style: const TextStyle(color: Colors.white70)),
                Text(
                  isRateButton ? 'Rate now to get Reward' : 'Join us to get Reward',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isRateButton ? Colors.blue : const Color(0xFF3B4455),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildIllustrationCard(),
            const SizedBox(height: 25),
            _buildEarningMethodCard(
              icon: Icons.group,
              title: 'Invite Your Friends',
              subtitle: 'Par Reffer ₹5',
              buttonText: 'Invite',
              buttonColor: Colors.green,
            ),
            const SizedBox(height: 20),
            _buildEarningMethodCard(
              icon: Icons.menu_book,
              title: 'Read & Earn',
              subtitle: 'Read 3 Minutes & Earn ₹10',
              buttonText: 'Read Now',
              buttonColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF192131),
      title: const Row(
        children: <Widget>[
          // Placeholder for GT Battle Logo
          Text('GT Battle', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: <Widget>[
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

  Widget _buildIllustrationCard() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: Text(
          '',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildEarningMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF222B3B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white70, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            ),
            child: Text(buttonText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
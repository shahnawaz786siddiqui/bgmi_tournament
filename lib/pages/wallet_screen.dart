import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildWalletSection(),
            const Expanded(child: SizedBox()),
            _buildTotalBalance(),
            const SizedBox(height: 20),
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

  Widget _buildWalletSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF222B3B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('Wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Divider(color: Colors.white24, height: 25),
          _buildCashRow('Winning Cash', '₹', '0', 'Minimum Withdrawal Amount ₹100', Colors.green, 'Withdraw'),
          const Divider(color: Colors.white24, height: 25),
          _buildCashRow('Bonus Cash', '₹', '0', 'Not Withdrawal - Only Convert Then Withdraw', Colors.orange, 'Convert'),
        ],
      ),
    );
  }

  Widget _buildCashRow(String title, String currency, String amount, String subtitle, Color color, String buttonText) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                  children: [
                    TextSpan(
                      text: '$currency$amount',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.green),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(buttonText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTotalBalance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF222B3B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '₹0',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
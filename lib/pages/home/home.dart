import 'package:flutter/material.dart';
import 'package:insurance_boost_app/pages/authentication/authenticate.dart';
import 'package:insurance_boost_app/pages/home/packagepage.dart';
import 'package:insurance_boost_app/pages/home/reward.dart';
import 'package:insurance_boost_app/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Booster App'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: const OptionCard(
                asset: 'assets/images/up-arrow.png',
                text: 'Upload insurance document'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PackagePage()));
            },
            child: const OptionCard(
                asset: 'assets/images/gift.png',
                text: 'View available packages'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RewardPage()));
            },
            child: const OptionCard(
                asset: 'assets/images/money.png', text: 'Reward points'),
          ),
          GestureDetector(
            onTap: () {},
            child: const OptionCard(
                asset: 'assets/images/exchange.png', text: 'Refer a friend'),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
            },
            child: const Text("Log out"),
            style: ElevatedButton.styleFrom(primary: Colors.red[400]),
          )
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({Key? key, this.asset, this.text}) : super(key: key);
  final asset;
  final text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage(asset),
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 30),
            Text(text)
          ],
        ),
      ),
    );
  }
}

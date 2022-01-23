import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            onTap: () {},
            child: const OptionCard(
                asset: 'assets/images/gift.png',
                text: 'View available packages'),
          ),
          GestureDetector(
            onTap: () {},
            child: const OptionCard(
                asset: 'assets/images/exchange.png', text: 'Refer a friend'),
          ),
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

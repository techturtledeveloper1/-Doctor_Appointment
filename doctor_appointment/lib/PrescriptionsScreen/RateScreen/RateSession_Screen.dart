import 'package:flutter/material.dart';

class RateSessionScreen extends StatelessWidget {
  const RateSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Your Session")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const Text("Dr. Sarah Jones\nPsychiatrist", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber)),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(hintText: "Write additional feedback..."),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text("Polite")),
                Chip(label: Text("Helpful")),
                Chip(label: Text("Clear explanation")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}

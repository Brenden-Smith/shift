import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shift/layout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width >= 450;
    return Layout(
        body: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!large) const SizedBox(height: 50)
            else const Spacer(flex: 1),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircleAvatar(
                  radius: 75,
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: FilledButton(
                  onPressed: null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_camera),
                      SizedBox(width: 8),
                      Text("Change Photo"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                initialValue: FirebaseAuth.instance.currentUser!.displayName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Medic ID"),
                initialValue: "123456",
                readOnly: true,
              ),
            ),
            Row(
              children: [
                const Text("Notifications"),
                const Spacer(flex: 1),
                Switch(
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                )
              ],
            ),
            if (!large) const Spacer(flex: 1) else const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: logout,
                child: const Text("Save"),
              ),
            ),
            if (!large) const SizedBox(height: 50)
            else const Spacer(flex: 1),
          ],
        ),
      ),
    ));
  }
}

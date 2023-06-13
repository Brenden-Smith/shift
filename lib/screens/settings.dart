import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shift/layout.dart';
import 'package:shift/providers/user.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Expanded(
              child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child:
                Consumer<UserDataProvider>(builder: (context, userData, child) {
              TextEditingController nameController = TextEditingController(
                  text: userData.userData?["displayName"] ?? "");
              TextEditingController emailController =
                  TextEditingController(text: userData.userData?["email"] ?? "");
              TextEditingController medicIdController = TextEditingController(
                  text: userData.userData?["medicID"] ?? "");
        
              Future<void> pickImage(ImageSource source) async {
                final pickedFile = await ImagePicker().pickImage(source: source);
                if (pickedFile == null) return;
                await FirebaseStorage.instance
                    .ref()
                    .child("profile/${userData.user?.uid}.jpg")
                    .putFile(File(pickedFile.path));
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userData.user?.uid)
                    .update({
                  "photoURL": await FirebaseStorage.instance
                      .ref()
                      .child("profile/${userData.user?.uid}.jpg")
                      .getDownloadURL()
                });
              }
        
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (large) const Spacer(flex: 1),
                  Center(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: userData.userData?["photoURL"] != null
                          ? NetworkImage(userData.userData?["photoURL"])
                          : null,
                      child: userData.userData?["photoURL"] != null
                          ? null
                          : const Icon(Icons.person),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: FilledButton(
                        onPressed: () => pickImage(ImageSource.gallery),
                        child: const Row(
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    controller: nameController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    controller: emailController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Medic ID"),
                    readOnly: true,
                    controller: medicIdController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
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
                  ),
                  if (!large)
                    const Spacer(flex: 1)
                  else
                    const SizedBox(height: 50),
                  const Center(
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text("Save"),
                    ),
                  ),
                  if (large) const Spacer(flex: 1),
                ],
              );
            }),
          ),
              ),
            ),
        ));
  }
}

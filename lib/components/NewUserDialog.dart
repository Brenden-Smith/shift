import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({super.key});

  @override
  State<NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _medicIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late String role;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: _displayNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your displayName';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(
                          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Medic ID',
                ),
                controller: _medicIDController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your medic ID';
                  } else if (!RegExp(r'^(P|E)\d{3,}$').hasMatch(value)) {
                    return 'Please enter a valid medic ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Role',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'user',
                    child: Text('User'),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Administrator'),
                  ),
                ],
                validator: (value) =>
                    value == null ? 'Please select a role' : null,
                onChanged: (value) {
                  setState(() {
                    role = value.toString();
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await FirebaseFunctions.instance
                      .httpsCallable('createUser')
                      .call({
                    'displayName': _displayNameController.text,
                    'email': _emailController.text,
                    'medicID': _medicIDController.text,
                    'role': role,
                  });
                } on FirebaseFunctionsException catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message ?? 'An error occurred'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

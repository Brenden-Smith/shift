import 'package:flutter/material.dart';
import 'package:shift/components/DateTimePicker.dart';

class NewShiftDialog extends StatefulWidget {
  const NewShiftDialog({super.key});

  @override
  State<NewShiftDialog> createState() => _NewShiftDialogState();
}

class _NewShiftDialogState extends State<NewShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _unitController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _paramedicsController = TextEditingController();
  final _emtsController = TextEditingController();
  DateTime? start;
  DateTime? end;

  @override
  void dispose() {
    _unitController.dispose();
    _startController.dispose();
    _endController.dispose();
    _paramedicsController.dispose();
    _emtsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Shift'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _unitController,
              decoration: const InputDecoration(labelText: 'Unit'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a unit';
                }
                return null;
              },
            ),
            DateTimePicker(
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  start = newDateTime;
                });
              },
              labelText: 'Start',
              lastDate: end,
            ),
            DateTimePicker(
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  end = newDateTime;
                });
              },
              labelText: 'End',
              firstDate: start,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _paramedicsController,
                    decoration: const InputDecoration(labelText: 'Paramedics'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emtsController,
                    decoration: const InputDecoration(labelText: 'EMTs'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (start == null || end == null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text('Please enter a start and end time'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
                return;
              } else if (start!.isAfter(end!)) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text('Start time must be before end time'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ));
                return;
              } else {
                final shift = {
                  'unit': _unitController.text,
                  'start': _startController.text,
                  'end': _endController.text,
                  'slots': {
                    'paramedics': int.parse(_paramedicsController.text),
                    'emts': int.parse(_emtsController.text),
                  },
                };
                Navigator.of(context).pop(shift);
              }
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

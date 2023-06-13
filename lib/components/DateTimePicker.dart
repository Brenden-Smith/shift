import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {Key? key,
      required this.onDateTimeChanged,
      this.labelText,
      this.lastDate,
      this.firstDate})
      : super(key: key);

  final ValueChanged<DateTime> onDateTimeChanged;
  final String? labelText;
  final DateTime? lastDate;
  final DateTime? firstDate;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _dateTime;
  TextEditingController? _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: widget.labelText),
          controller: _controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a start date';
            } 
            return null;
          },
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateTime ?? DateTime.now(),
              firstDate: widget.firstDate ?? DateTime.now(),
              lastDate: widget.lastDate ??
                  DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null && context.mounted) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(_dateTime ?? DateTime.now()),
              );

              if (time != null) {
                final dateTime = DateTime(
                    date.year, date.month, date.day, time.hour, time.minute);
                setState(() {
                  _dateTime = dateTime;
                  _controller!.text =
                      DateFormat.yMd().add_jm().format(dateTime);
                });
                widget.onDateTimeChanged.call(dateTime);
              }
            }
          },
        ),
      ],
    );
  }
}

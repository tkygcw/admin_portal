import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final String? date;
  final Function(String?) callBack;

  DatePicker({this.date, required this.callBack});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late String date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = widget.date ?? DateTime.now().toString();
    print('data $date');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        title: new Text('Date'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
            ),
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
            ),
            child: Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              widget.callBack(date);
              Navigator.of(context).pop();
            },
          ),
        ],
        content: Container(
          height: 320,
          width: 350,
          child: SfDateRangePicker(
            minDate: DateTime.now(),
            showTodayButton: true,
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.single,
            initialDisplayDate: (date.isNotEmpty ? DateTime.parse(date) : DateTime.now()),
            initialSelectedDate: (date.isNotEmpty ? DateTime.parse(date) : DateTime.now()),
          ),
        ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    date = DateFormat('yyyy-MM-dd').format(args.value);
  }
}

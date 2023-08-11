import 'package:buspassapp/api_service.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanLogs extends StatelessWidget {
  const ScanLogs({super.key});
  @override
  Widget build(context) {
    return const Scaffold(body: Calendar());
  }
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDate;
  late String displayDate;
  late Future<List<dynamic>> _scanDetails;
  dynamic _isLogAvailable;
  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void setLogAvaiable(bool valuetobeset) {
    setState(() {
      _isLogAvailable = valuetobeset;
    });
  }

  void _resetSelectedDate() {
    _selectedDate =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    // print(_selectedDate.toString());
    displayDate = DateFormat("d-MM-yyyy").format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01267C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Scan Logs',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: const Color.fromARGB(255, 248, 166, 33)),
              ),
            ),
            CalendarTimeline(
              showYears: true,
              initialDate: _selectedDate,
              firstDate: DateTime.utc(DateTime.now().year, DateTime.january, 1),
              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
              //on clicking a specific date
              onDateSelected: (date) => setState(() {
                _selectedDate = date;
                displayDate = DateFormat("d-MM-yyyy").format(_selectedDate);
                //api calling to get scan logs
                _scanDetails =
                    Future.value(ScanService(date: displayDate).getDetails());
                //to check if the log is available
                _scanDetails.then((value) {
                  //calling setState hook in after fetch the value
                  if (value.isEmpty) {
                    setLogAvaiable(false);
                  } else {
                    setLogAvaiable(true);
                  }
                });
              }),
              leftMargin: 20,
              monthColor: Colors.white70,
              dayColor: const Color(0xFFc4e49c),
              dayNameColor: const Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: const Color(0xFFd42c44),
              dotsColor: const Color(0xFF333A47),
              locale: 'en',
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _isLogAvailable == true
                    ? 'Selected date is $displayDate'
                    : 'Scan Log Not Found',
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

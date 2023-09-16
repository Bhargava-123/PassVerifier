import 'package:buspassapp/api_service.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';

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
    displayDate = DateFormat("d-MM-yyyy").format(DateTime.now());
    _scanDetails =
        Future.value(getScanLogService(date: displayDate).getDetails());
    _scanDetails.then((value) {
      //calling setState hook in after fetch the value
      if (value.isEmpty) {
        setLogAvaiable(false);
      } else {
        setLogAvaiable(true);
      }
    });
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF01267C),
        shadowColor: const Color.fromARGB(0, 255, 255, 255),
        title: const Text(
          "Scan Logs",
          style:
              TextStyle(fontSize: 23, color: Color.fromARGB(255, 248, 166, 33)),
        ),
      ),
      backgroundColor: const Color(0xFF01267C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Text(
            //     'Scan Logs',
            //     style: Theme.of(context)
            //         .textTheme
            //         .titleLarge!
            //         .copyWith(color: const Color.fromARGB(255, 248, 166, 33)),
            //   ),
            // ),
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
                _scanDetails = Future.value(
                    getScanLogService(date: displayDate).getDetails());
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
            const SizedBox(height: 10),
            // const SizedBox(height: 20),
            Center(
              child: _isLogAvailable == true
                  ? ScanLogListWidget(logList: _scanDetails)
                  : const Text(
                      'Scan Log Not Found',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanLogListWidget extends StatelessWidget {
  final Future<List<dynamic>> logList;
  const ScanLogListWidget({super.key, required this.logList});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: logList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height - 240.375,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      return LogRowWidget(
                          bioId: data['bio_id'].toString(),
                          name: data['student_name'].toString(),
                          scanDate: data['scan_date'],
                          scanTime: data['scan_time']);
                    },
                  ),
                ),
              ],
            ));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class LogRowWidget extends StatelessWidget {
  final String bioId;
  final String scanDate;
  final String scanTime;
  final String name;
  final TextStyle whiteText =
      const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 25);
  const LogRowWidget(
      {super.key,
      required this.bioId,
      required this.scanDate,
      required this.scanTime,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 255, 254, 254), width: 0.5),
              bottom: BorderSide(
                  color: Color.fromARGB(255, 255, 254, 254), width: 0.5))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // Text(bioId, style: whiteText),
        BioIdDetails(bioId: bioId, name: name),
        Text(
          scanTime,
          style: whiteText,
        ),
      ]),
    );
  }
}

class BioIdDetails extends StatelessWidget {
  final String bioId;
  final String name;
  const BioIdDetails({super.key, required this.bioId, required this.name});
  final TextStyle whiteText =
      const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: whiteText),
        Text(bioId,
            style: const TextStyle(
                color: Color.fromARGB(184, 254, 254, 254), fontSize: 15))
      ]),
    );
  }
}

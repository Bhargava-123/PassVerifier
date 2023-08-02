import 'package:flutter/material.dart';

class ScanLogs extends StatelessWidget {
  const ScanLogs({super.key});
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Logs'),
        ),
        body: const Center(child: Text('Scan Logs Screen')));
  }
}

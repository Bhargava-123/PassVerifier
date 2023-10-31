import 'package:buspassapp/api_service.dart';
import 'package:flutter/material.dart';

class PassDetails extends StatefulWidget {
  const PassDetails({super.key});

  @override
  State<PassDetails> createState() => _PassDetailsState();
}

class _PassDetailsState extends State<PassDetails> {
  late Future<List<dynamic>> _passDetails;

  void getDetails(String bioId) {
    setState(() {
      _passDetails = Future.value(PassService(bioId: bioId).getDetails());
    });
  }
  //snapshot.data[index]

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    String bioId = arguments['data'].toString();
    getDetails(bioId); //api call
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pass Details"),
      ),
      body: FutureBuilder(
          future: _passDetails,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data[index].runtimeType.toString());
                },
              );
            } else if (snapshot.hasError) {
              // If something went wrong
              return const Center(child: Text('Something went wrong...'));
            }

            // While fetching, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

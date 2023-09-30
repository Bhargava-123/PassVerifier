import 'package:flutter/material.dart';
import 'package:buspassapp/api_service.dart';

class PassDetailsScreen extends StatefulWidget {
  const PassDetailsScreen({super.key});

  @override
  State<PassDetailsScreen> createState() => _PassDetailsScreenState();
}

class _PassDetailsScreenState extends State<PassDetailsScreen> {
  late Future<List<dynamic>> _passDetails;

  void getDetails(String bioId) {
    setState(() {
      _passDetails = Future.value(PassService(bioId: bioId).getDetails());
      // print(PassService(bioId: bioId).getDetails());
    });
  }

  @override
  Widget build(BuildContext context) {
    //data from qr code
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    String bioId = arguments['data'].toString();
    //API call to get the details of the bioID scanned
    getDetails(bioId);
    //API call to post the data to scanLog

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 55, 161),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/home");
              // print("went home");
            },
            child: const Text('Pass Details')),
        backgroundColor: const Color(0xFF00127C),
      ),
      body: FutureBuilder(
          future: _passDetails,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //The QR Code is invalid
            if (snapshot.data == '[]') {
              return const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Invalid Scan",
                          style: TextStyle(
                              fontSize: 25, color: Color(0xFFFFFFFF))),
                      SizedBox(width: 100, height: 550),
                      ScanAgain(),
                      SizedBox(height: 40),
                    ]),
              );
            }
            //The Qr Code is Valid
            else if (snapshot.hasData) {
              //the id is not found
              //post bioid to scanLog once the QR is valid
              // print("hello");
              PostScanLogService(bioId: bioId,studentName: snapshot.data[0]['student_name']).postScanLog();

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ColumnWidget(responseList: snapshot.data[index]);
                },
              );
            } else if (snapshot.hasError) {
              // If something went wrong
              // print("some error occured");
              return const Center(child: Text('Something went wrong...'));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class ColumnWidget extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const ColumnWidget({super.key, required this.responseList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        PassDetailsWidget(responseList: responseList),
        const SizedBox(
          height: 30,
        ),
        ValidityDetailsWidget(
            isValid: responseList['isTransport'],
            dept: "Transport",
            responseList: responseList),
        const SizedBox(
          height: 5,
        ),
        ValidityDetailsWidget(
            isValid: responseList['isHostel'],
            dept: "Hostel",
            responseList: responseList),
        const SizedBox(
          height: 20,
        ),
        const ScanAgain()
      ],
    );
  }
}

class PassDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const PassDetailsWidget({super.key, required this.responseList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: 330,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 226, 241),
          border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DepartmentHeading(responseList: responseList),
          PassImage(responseList: responseList),
          StudentDetail(responseList: responseList),
          //Semi Circle
          SemiCircle(responseList: responseList),
        ],
      ),
    );
  }
}

class DepartmentHeading extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const DepartmentHeading({super.key, required this.responseList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 330,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          responseList['institution']!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}

class StudentDetail extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const StudentDetail({super.key, required this.responseList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          responseList['student_name'],
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          responseList['reg_number'],
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          responseList['department'] + " " + responseList['year'],
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }
}

class PassImage extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const PassImage({super.key, required this.responseList});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      responseList['image_url'],
      height: 200,
      width: 200,
    );
  }
}

class SemiCircle extends StatelessWidget {
  final Map<String, dynamic> responseList;
  const SemiCircle({super.key, required this.responseList});
  final TextStyle textStyle =
      const TextStyle(fontSize: 25, fontWeight: FontWeight.w800);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 125,
      decoration: BoxDecoration(
        color: const Color.fromARGB(109, 0, 35, 233).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.elliptical(250, 160),
          topRight: Radius.elliptical(250, 160),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_interpolation_to_compose_strings
          Text("", style: textStyle),
          Text(
            '',
            style: textStyle,
          ),
          Text(
            "BIO ID : " + responseList['bio_id'].toString(),
            style: textStyle,
          )
        ],
      ),
    );
  }
}

class ValidityDetailsWidget extends StatelessWidget {
  final bool isValid;
  final String dept;
  final Map<String, dynamic> responseList;
  const ValidityDetailsWidget(
      {required this.isValid,
      required this.dept,
      super.key,
      required this.responseList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isValid ? const Color(0xFF6CBC34) : const Color(0xFFD03044),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 30,
          ),
          Column(children: [
            Text(dept,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            Text(
              dept == "Transport"
                  ? (isValid
                      ? "Valid Upto : " + responseList['valid_upto_bus']
                      : "Not Valid")
                  : (isValid
                      ? "Valid Upto : " + responseList['valid_upto_hostel']
                      : "Not Valid"),
            )
          ]),
          Container(
            padding: const EdgeInsets.only(right: 5),
            child: isValid
                ? Image.asset('assets/images/tick.png')
                : Image.asset('assets/images/wrong.png'),
          )
        ],
      ),
    );
  }
}

class ScanAgain extends StatelessWidget {
  const ScanAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        width: MediaQuery.of(context).size.width - 35,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/scanner');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8A521),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Scan Again",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
        ));
  }
}

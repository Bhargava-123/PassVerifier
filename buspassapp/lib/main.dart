import 'package:buspassapp/pass_details_screen';
import 'package:flutter/material.dart';
import 'package:buspassapp/scan_logs.dart';
import 'package:buspassapp/scanner.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Montserrat'),
    title: "Named Routes Demo",
    initialRoute: '/',
    routes: {
      '/': (context) => const MyApp(),
      '/scanLogs': (context) => const ScanLogs(),
      '/scanner': (context) => Scanner(),
      '/passDetails' : (context) => const PassDetailsScreen(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Padding(
          padding: EdgeInsets.only(top : 15.0),
          child: Center(
            child: Text("Pass Verifier",style: TextStyle(fontSize: 35),
            ),
          ),
        ),backgroundColor: const Color(0xFF01267C),shadowColor: const Color.fromARGB(0, 255, 255, 255),),
        backgroundColor: const Color(0xFF01267C),
        body: Column(
        
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Image.asset('assets/images/seclogo.png',height: 170,width: 170,),
            ),

            
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
               
               Button('Scan Logs','/scanLogs'),
                SizedBox(height: 50,width: 100,),
               Button('Scanner','/scanner')
               
              ],
            ),
          ],
        )
      );
  }
}
class Button extends StatelessWidget {
  final String buttonName;
  final String routeName;
  const Button(this.buttonName,this.routeName,{super.key});
  @override
  Widget build(context){
    return  
    Center(
      child: ElevatedButton(
            onPressed: () 
            {
              Navigator.pushNamed(context, routeName);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(320,180),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: const Color.fromARGB(255, 248, 166, 3)
            ),
            child: Text(buttonName,style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold
               ),
        
        ),
      )
    );
  } 
}

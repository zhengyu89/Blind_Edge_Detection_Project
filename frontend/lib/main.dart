import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/features/edge_detection/presentation/pages/camera_page.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:frontend/firstpage.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});


@override
Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home:SplashScreen(),
    //home:CameraPage(),
  );
 }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CameraPage()),
      );
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB89261),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/HearWay_Logo_RemoveBG.png',
              width:150,
              height:150,
            ),
            SizedBox(height:20),
          Text(
          'HearWay',
          style: GoogleFonts.dancingScript(
            fontSize: 40, 
            fontWeight: FontWeight.bold,
            color: Colors.white),
            ),
          ],
        ),
      ),  
    );
  }
}

/* move to next page 
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("blablabla"),
    ),
    body: Center(
      child: ElevatedButton(
        child: Text("go to blabla page"),
        onPressed: () {
          // Navigate to the next page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ),
          );
        },
      ),
    ),
  );
}

*/


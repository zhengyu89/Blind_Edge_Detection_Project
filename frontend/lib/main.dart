import 'package:flutter/material.dart';
import 'package:frontend/features/edge_detection/presentation/pages/camera_page.dart';
import 'firstpage.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});


@override
Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home:CameraPage(), // home:FirstPage()
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


import 'package:flutter/material.dart';
import 'package:flutter_vs/firstpage.dart';
//bug settle later

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});


@override
Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home:FirstPage(),
  );
 }
}
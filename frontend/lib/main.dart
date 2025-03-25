import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'firstpage.dart';

=======
import 'package:frontend/firstpage.dart';

//bug settle later
>>>>>>> 3246f2d5eb38f8c8622ce6dc49bf41b2942f6fe6

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
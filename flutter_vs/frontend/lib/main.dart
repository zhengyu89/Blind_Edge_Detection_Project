import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        backgroundColor: Color.fromARGB(255, 116, 199, 237),
        body:Center(
        child: Container(
          height:300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
        )
      ) 
      ),
    );
  }
}

//wahhhhhhhh


  
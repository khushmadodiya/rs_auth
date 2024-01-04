import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Greating extends StatelessWidget {
  const Greating({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Thank You",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
    );
  }
}

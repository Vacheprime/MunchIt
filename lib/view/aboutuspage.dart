import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Munch't"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
      ),
      body: Center(
        child: Column(
          children: [
            Text("About Us", style: TextStyle(fontSize: 48),),
            SizedBox(height: 20,),
            Text(""),
          ],
        ),
      ),
    );
  }
}
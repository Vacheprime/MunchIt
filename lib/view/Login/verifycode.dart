import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Verification", style: TextStyle(fontSize: 24),),
            //code
            SizedBox(height: 35,),
            ElevatedButton(onPressed: () {}, child: Text("Next", style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),))
          ],
        ),
      )
    );
  }
}

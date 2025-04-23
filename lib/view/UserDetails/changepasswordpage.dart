import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Change Password", style: TextStyle(fontSize: 24),),
            SizedBox(height: 25,),
            TextField(),
            SizedBox(height: 15,),
            TextField(),
            SizedBox(height: 15,),
            TextField(),
            SizedBox(height: 35,),
            ElevatedButton(onPressed: () {/*update functionality*/}, child: Text("Change", style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),))
          ],
        ),
      ),
    );
  }
}

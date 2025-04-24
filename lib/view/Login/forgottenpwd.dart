import 'package:flutter/material.dart';
import 'package:munchit/view/settingspage.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {

  TextEditingController resetPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text("Munch't"),
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Reset Password"),
            TextField(
              controller: resetPassword,
              decoration: InputDecoration(
                hintText: "Email or Phone Number"
              ),
            ),
            SizedBox(height: 35,),
            ElevatedButton(onPressed: () { /*send the verification code and send to where the user can input the code*/ }, child: Text("Next", style: TextStyle(color: Color.fromRGBO(248, 145, 145, 1)),))
          ],
        ),
      ),
    );
  }
}

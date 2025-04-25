import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../settingspage.dart';
import 'accountpage.dart';

class Stats extends StatefulWidget {
  final User user;

  const Stats({super.key, required this.user});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 145, 145, 1),
        leading: IconButton(onPressed: () {
          Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Color.fromRGBO(248, 145, 145, 1)),
                  child: const Center(
                      child: Text("Options", style: TextStyle(fontSize: 24))),
                ),
                ListTile(
                  title: Text("• Account"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Account(user: widget.user)));
                  },
                ),
                ListTile(
                  title: Text("• Your Stats"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Stats(user: widget.user)));
                  },
                ),
                ListTile(
                  title: Text("• Settings"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings(user: widget.user ,)));
                  },
                ),
              ],
            ),
          );
        }, icon: Icon(Icons.menu)),
        title: Text("Munch't"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back_outlined))
        ],
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Likes", style: TextStyle(fontSize: 24),),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Favourites", style: TextStyle(fontSize: 24),),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Reviews", style: TextStyle(fontSize: 24),),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Created Restaurants", style: TextStyle(fontSize: 24),),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Created Foods", style: TextStyle(fontSize: 24),),
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
            ],
          ),
        ],
      ),
      ),
    );
  }
}

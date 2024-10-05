import 'package:counter_app/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  final User? user;

  CounterScreen({required this.user});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final snapshot = await _databaseRef.child('users/${widget.user!.uid}/counter').get();
    if (snapshot.exists) {
      setState(() {
        _counter = snapshot.value as int;
      });
    }
  }
   Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,  
    );
  }
  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await _databaseRef.child('users/${widget.user!.uid}/counter').set(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 164, 35, 211),
        title: Text("Counter App"),
      actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.black,),
            onPressed: _logout, 
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient( 
          colors: [Colors.blue,Colors.purple],
          center: Alignment.center,
          radius: 1.0,
        ),
      
        ),
        child:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text(
                'Hello: ${widget.user?.email ?? "Unknown"}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), 
            Text('Your current count is:', style: TextStyle(fontSize: 20)),
            Text('$_counter', style: Theme.of(context).textTheme.headlineLarge, ),            
           SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text("Increment"),
            ),
            
          ],
        ),
      ),
    ),
    );
  }
}

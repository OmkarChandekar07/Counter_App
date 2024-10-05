import 'package:counter_app/counterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CounterScreen(user: userCredential.user)),
      );
    } catch (e) {
      print(e); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(231, 65, 180, 50),
        title: Text("Register")),
      body: Stack(
        children: [
        Container(
decoration:const BoxDecoration(
        gradient: LinearGradient(
        colors: [Colors.green, Colors.lightGreen, Colors.lime],
           stops: [0.0, 0.5, 1.0],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           tileMode: TileMode.clamp,
        ),
      ),        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20,),
             TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: register,
                child: Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
            ],
          )
      
    );
  }
}

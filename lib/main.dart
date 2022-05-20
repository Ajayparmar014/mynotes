// ignore_for_file: avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

import 'package:mynotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/register.dart';
import 'firebase_options.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      title: 'My notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const LoginPage(),
      routes: {'/register/':(context)=>const RegisterPage(),},
      
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
          case ConnectionState.done:
          return Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email id',
                  label: Text("User Email Id"),
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Enter Passwor",
                  label: Text("Password"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print(userCredential);
                    } on FirebaseAuthException catch (e) {
                      // print(" print something bad ");
                      // print(e.runtimeType);
                      // print(e.code);
                      if (e.code == 'user-not-found') {
                        print("user not found");
                      } else if (e.code==""){
                      }
                      // else{
                      //   print('something else happend');
                      //   print(e.code);
                      // }
                    }
                  },
                  child: const Text("Login")),
                  TextButton(onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false,);
                  }, child: const Text("Not registered yet? Register here!"))
            ],
          );
        default:
        return const Text('Loading....');
          }
          },
          ),  
    
    );
  }
}


// ignore: avoid_web_libraries_in_flutter, unused_import
// ignore_for_file: avoid_print, unused_import, duplicate_ignore, avoid_web_libraries_in_flutter, sized_box_for_whitespace, use_build_context_synchronously

//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/profile_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    home:  HomePage(),
    );
  }
}
class HomePage extends StatefulWidget{
  // ignore: use_key_in_widget_constructors
   const HomePage({Key?key}) : super(key : key);
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() =>_HomePageState();
}
class _HomePageState extends State<HomePage>{
  Future<FirebaseApp> _initializeFirebase()async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp ;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
       body:FutureBuilder(
        future: _initializeFirebase(),
        builder:(context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            // ignore: prefer_const_constructors
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
       ),
       );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
 @override
 // ignore: library_private_types_in_public_api
 _LoginScreenState createState()=>_LoginScreenState();
  
}

class _LoginScreenState extends State<LoginScreen> {
  

  static Future<User?>loginusingEmailPassword(
    {required String email,
    required String password,
    required BuildContext context})async{
      FirebaseAuth auth =FirebaseAuth.instance;
  User?user;
    
  
  try  {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email, password: password);
    user = userCredential.user;
  // ignore: non_constant_identifier_names
  } on FirebaseAuthException catch (e) {
    if(e.code == "user - not - found") {
      print("No user found for that email");
    }
    }
    // ignore: prefer_typing_uninitialized_variables
    return user; 
}
     
  @override

  Widget build (BuildContext context){
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    
    return Padding(
      padding:const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const Text("My App", 
          style:TextStyle(
            color: Colors.blueAccent,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            ),
            ),
        
        
            const Text(
              "Login to your app",
              style: TextStyle(
                color: Colors.blueAccent,
              fontSize:44.0,
              fontWeight: FontWeight.bold
            ),
            ),
            const SizedBox(
              height: 44.0,
            ), 
             TextField(
              controller : emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:   const InputDecoration(
                hintText: "User Email",
                prefixIcon: Icon(Icons.email_rounded)
              ),
            ),
            const SizedBox(
              height: 26.0,
            ),
             TextField(
              controller: passwordController,
              obscureText: true,
              decoration:const InputDecoration(
                hintText: "UserPassword",
                prefixIcon: Icon(Icons.lock,color:Colors.black),
              ) ,
            ),
            const SizedBox(
              height:12.0,
            ),
            const Text(
              "Type the correct password",
              style: TextStyle(color:Colors.blue),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Container(
          width: double.infinity,
          child:RawMaterialButton(
             fillColor:const Color(0xFF0069FE),
             elevation:0.0,
             padding: const EdgeInsets.symmetric(vertical: 20.0),
             shape: RoundedRectangleBorder( borderRadius:BorderRadius.circular(12.0)),
               onPressed: () async {
                User? user = await loginusingEmailPassword(email: emailController.text, password: passwordController.text, context: context);
                print(user);
                if(user != null){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=> const ProfileScreen()));

                }
               }, 
            child: const Text("Login",
            style: TextStyle(
              color:Colors.white,
)),
                ),
              ),
        ],
      ),
    );
  }
}

  
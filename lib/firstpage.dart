import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  bool pass = true;
  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
     ),
     body:  Column(
       children: [
         Container(
           margin: EdgeInsets.all(10),
           child: TextField(
             controller: t1,
             maxLines: 1,
             decoration: InputDecoration(
               enabledBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.blue),
               ),
               focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.pink),
               ),
               labelText: 'Email',
               hintText: 'enter your email',
               border: OutlineInputBorder(),
             ),
           ),
         ),
         Container(
           margin: EdgeInsets.all(10),
           child: TextField(
             controller: t2,
             obscureText: pass,
             maxLength: 8,
             decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.blue),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.red),
                 ),
                 labelText: 'password',
                 hintText: 'enter your password',
                 border: OutlineInputBorder(),
                 suffix: InkWell(
                   onTap: (){
                     pass =!pass;
                     setState(() {});
                   },
                   child: Icon(Icons.visibility_off_sharp,
                     color: Colors.black,
                   ),
                 ),
             ),
           ),
         ),
         ElevatedButton(onPressed: () async {
           try {
             UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
               email: t1.text,
               password: t2.text,
             );
             await credential.user!.sendEmailVerification();

             print(credential.user!.email);
             print(credential.user!.uid);
             print(credential);
           } on FirebaseAuthException catch (e) {
             if (e.code == 'weak-password') {
               print('The password provided is too weak.');
             } else if (e.code == 'email-already-in-use') {
               print('The account already exists for that email.');
             }
           } catch (e) {
             print(e);
           }
         }, child: Text("sing up"))
       ],
     ),
   );
  }
}

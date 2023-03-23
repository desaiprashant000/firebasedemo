import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/firstpage.dart';
import 'package:firebasedemo/phone.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: myapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  bool pass = true;

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
        // Navigator.pushReplacement(context, MaterialPageRoute(
        //   builder: (context) {
        //     return firstpage();
        //   },
        // ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                    onTap: () {
                      pass = !pass;
                      setState(() {});
                    },
                    child: Icon(
                      Icons.visibility_off_sharp,
                      color: Colors.black,
                    ),
                  )),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleSignInAccount =
                          await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication
                          googleSignInAuthentication =
                          await googleSignInAccount!.authentication;
                      final AuthCredential authCredential =
                          GoogleAuthProvider.credential(
                              accessToken:
                                  googleSignInAuthentication.accessToken,
                              idToken: googleSignInAuthentication.idToken);
                      await FirebaseAuth.instance
                          .signInWithCredential(authCredential);
                    } on FirebaseAuthException catch (e) {
                      print('Error ${e.message}');
                    }
                  },
                  style: ButtonStyle(),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: Text('Google ')),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: t1.text, password: t2.text);
                  print(credential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              },
              child: Text("Login")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return firstpage();
                  },
                ));
              },
              child: Text('Register')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Phone();
                  },
                ));
              },
              child: Text('phone'))
        ],
      ),
    );
  }
}

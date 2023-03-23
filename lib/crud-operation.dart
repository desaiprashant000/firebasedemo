import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class crudoperation extends StatefulWidget {
  const crudoperation({Key? key}) : super(key: key);

  @override
  State<crudoperation> createState() => _crudoperationState();
}

class _crudoperationState extends State<crudoperation> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  List keylist = [];
  List namelist = [];
  List Contactlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: t1,
          ),
          TextField(
            controller: t2,
          ),
          ElevatedButton(
              onPressed: () async {
                DatabaseReference ref =
                    FirebaseDatabase.instance.ref("users").push();
                await ref.set({
                  "name": t1.text,
                  "contact": t2.text,
                });
              },
              child: Text("data Insert")),
          ElevatedButton(
              onPressed: () {
                DatabaseReference StarCountRef =
                    FirebaseDatabase.instance.ref("users");
                StarCountRef.onValue.listen((event) {
                  if (event.snapshot.exists) {
                    print(event.snapshot.value);
                    Map m = event.snapshot.value as Map;
                    print(m);
                    m.forEach((key, value) {
                      keylist.add(key);
                      Map childmap = value;
                      namelist.add(childmap['name']);
                      Contactlist.add(childmap['contact']);
                    });
                    print('keylist');
                    print('namelist');
                    print('contactlist');
                  } else {
                    print('No data available.');
                  }
                });
              },
              child: Text("Get Data")),
        ],
      ),
    );
  }
}

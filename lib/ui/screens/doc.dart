import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simba_ultimate/constants.dart';

class GetDocs extends StatefulWidget {
  const GetDocs({Key? key}) : super(key: key);

  @override
  _GetDocsState createState() => _GetDocsState();
}

class _GetDocsState extends State<GetDocs> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }

          var userDocument = snapshot.data.toString();
          var name = userDocument.length;
          print(name);
          return Text(userDocument.toString());
        });
  }
}

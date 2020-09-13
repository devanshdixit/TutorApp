import 'package:tutorApp/models/subject.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ApprovedList extends StatefulWidget {
  @override
  _ApprovedListState createState() => _ApprovedListState();
}

class _ApprovedListState extends State<ApprovedList> {
  List<Teacher> teacher = [];
  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('Users')
        .where('approved', isEqualTo: 0)
        .getDocuments();
  }

  Teacher buildTeacherList(DocumentSnapshot documentSnapshot) {
    return Teacher(
      name: documentSnapshot['name'],
      description: documentSnapshot['description'],
      age: documentSnapshot['age'],
      email: documentSnapshot['email'],
      exp: documentSnapshot['exp'],
      phoneno: documentSnapshot['phoneno'],
      photo: documentSnapshot['photo'],
      subjects: documentSnapshot['subjects'],
      uid: documentSnapshot.documentID,
      url: documentSnapshot['url'],
      point: documentSnapshot['location']['geopoint'],
      price: documentSnapshot['price'],
    );
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration mbox = BoxDecoration(
        color: Colors.white.withOpacity(0.010),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500].withOpacity(0.10),
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ]);
    return FutureBuilder<QuerySnapshot>(
      future: getData(),
      builder: (context, snapshot) {
        teacher = snapshot.data.documents.map(buildTeacherList).toList();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
              child: Text(
                "There are " +
                    teacher.length.toString() +
                    " teachers to be approved",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: teacher.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {},
                      child: FadeInUp(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            color: Color.fromARGB(225, 221, 230, 232),
                          ),
                          child: Card(
                            color: Color.fromARGB(225, 221, 230, 232),
                            elevation: 0.0,
                            child: ListTile(
                              title: Text(
                                teacher[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                teacher[index].subjects,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(teacher[index].url),
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorApp/loading.dart';
import 'package:tutorApp/models/subject.dart';
import 'package:tutorApp/models/user.dart';

class ParentDashBoard extends StatefulWidget {
  String uid;
  ParentDashBoard({this.uid});
  @override
  _ParentDashBoardState createState() => _ParentDashBoardState();
}

class _ParentDashBoardState extends State<ParentDashBoard> {
  List<Teacher> teacher = [];
  List teacherid = [];
  String child;
  bool loading = false;
  String newclass, completed, confirmed, classes;

  getFuture() async {
    return await Firestore.instance.collection('Users').getDocuments();
  }

  getdata() async {
    await Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .get()
        .then((value) {
      if (value.data['child'] != null) {
        setState(() {
          child = value.data['child'];
        });
      }
    });
    await Firestore.instance
        .collection('Users')
        .document(child)
        .get()
        .then((value) {
      if (value.data['teachers'] != null) {
        setState(() {
          teacherid = value.data['teachers'];
        });
      }
    });
    teacherid.forEach((element) async {
      await getList(element);
    });
    setState(() {
      loading = false;
    });
  }

  Future getList(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .get()
        .then((value) {
      teacher.add(Teacher(
        name: value.data['name'],
        description: value.data['description'],
        age: value.data['age'],
        email: value.data['email'],
        exp: value.data['exp'],
        phoneno: value.data['phoneno'],
        photo: value.data['photo'],
        subjects: value.data['subjects'],
        uid: value.documentID,
        url: value.data['url'],
        point: value.data['location']['geopoint'],
        price: value.data['price'],
      ));
    });
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration mbox = BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ]);
    return loading
        ? Loading()
        : FutureBuilder(
            future: getFuture(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Text(
                      "Your child have " +
                          teacher.length.toString() +
                          " classes to attend",
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
                            child: Container(
                              decoration: mbox,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
  }
}

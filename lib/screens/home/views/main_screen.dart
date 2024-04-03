import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:coin_compass/screens/home/views/home_screen.dart';
import 'package:coin_compass/screens/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late User? _user;
  DocumentSnapshot? _userData;

  @override
  void initState() {
    super.initState();
    fetchPrice();
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      setState(() {
        _userData = userDoc;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Scaffold(
          body: _user != null
              ? _userData != null
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        _userData!['photoUrl'],
                                      ),
                                      radius: 23,
                                    ),
                                    /* Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.yellow[800],
                          )*/
                                  ],
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome!",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    Text(
                                      _userData!['username'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingsScreen()));
                                },
                                icon: Icon(CupertinoIcons.settings)) //
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.grey.shade300,
                                    offset: Offset(5, 5))
                              ],
                              gradient: LinearGradient(colors: [
                                Colors.green,
                                Colors.blue,
                                Color(0xffE064f7),
                                // Replace with your desired gradient colors
                              ], transform: const GradientRotation(pi / 4))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Balance",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "₹${_userData!['monthlyIncome'] - amount}",
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white30,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            CupertinoIcons.arrow_down,
                                            size: 12,
                                            color: Colors.greenAccent,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Income",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "₹${_userData!['monthlyIncome']}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white30,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            CupertinoIcons.arrow_down,
                                            size: 12,
                                            color: Colors.red,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Expenses",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "₹${amount}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Remove Item"),
                                        content: Text(
                                            "Are you sure you want to remove all transaction?"),
                                        actions: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                deleteSubcollection();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()),
                                                    (route) => false);
                                              },
                                              icon: Icon(
                                                Icons.done,
                                                color: Colors.green,
                                              ))
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Clear All",
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("userdata")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Something is wrong"),
                                  );
                                }
                                try {
                                  if (snapshot.data!.docs.length == 0) {
                                    return Scaffold(
                                      body: Center(
                                          child: Column(
                                        children: [
                                          Lottie.asset("assets/empty.json"),
                                          Text(
                                            "Your Transactions is Empty",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                    );
                                  }
                                } catch (exception) {}
                                return ListView.builder(
                                  itemCount: snapshot.data == null
                                      ? 0
                                      : snapshot.data!.docs.length,
                                  itemBuilder: (_, index) {
                                    DocumentSnapshot _documentSnapshot =
                                        snapshot.data!.docs[index];
                                    return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            label: "Delete",
                                            onPressed: (context) async {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Remove Item"),
                                                      content: Text(
                                                          "Are you sure you want to remove this transaction?"),
                                                      actions: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              color: Colors.red,
                                                            )),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                                  .collection(
                                                                      "userdata")
                                                                  .doc(
                                                                      _documentSnapshot
                                                                          .id)
                                                                  .delete();

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()));
                                                            },
                                                            icon: Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green,
                                                            ))
                                                      ],
                                                    );
                                                  });
                                            },
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      int.parse(
                                                                    _documentSnapshot[
                                                                            "color"]
                                                                        .substring(
                                                                            6,
                                                                            16),
                                                                  )),
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                        _documentSnapshot[
                                                                    "icon"] ==
                                                                ''
                                                            ? Lottie.asset(
                                                                "assets/nodata.json",
                                                                height: 40,
                                                                width: 40)
                                                            : Lottie.asset(
                                                                "assets/${_documentSnapshot["icon"]}.json",
                                                                height: 40,
                                                                width: 40)
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      _documentSnapshot["name"],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "₹${_documentSnapshot["totalExpenses"].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      _documentSnapshot["date"],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .outline,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        )
                      ],
                    )
                  : Center(
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                    )
              : Center(
                  child: Text('User not authenticated'),
                ),
        ),
      ),
    );
  }

  int amount = 0;
  int? sum = 0;

  void fetchPrice() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userdata")
        .get();

    List<Map<String, dynamic>?>? documentData = data?.docs
        .map((e) => e.data() as Map<String, dynamic>?)
        .toList(); //working

    int len = documentData!.length;
    int price = documentData![0]!['totalExpenses'];

    for (int i = 0; i < len; i++) {
      sum = (sum! + documentData![i]!['totalExpenses']) as int?;
      print('i ' + i.toString() + ' amt: ' + sum.toString());
    }
    setState(() {
      amount = sum!;
    });
  }

  Future<void> deleteCurrentUserDocuments() async {
    try {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Query Firestore collection for documents related to the current user
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("userdata") // Replace with your collection name
            .where('categoryId',
                isEqualTo: userId) // Replace with your user ID field
            .get();

        // Delete each document
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          await documentSnapshot.reference.delete();
        }
      }
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  void deleteSubcollection() async {
    // Assuming you have a reference to the current user's document
    // and the subcollection is called 'mySubcollection'
    final userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference userDocument = userCollection.doc(userId);
    CollectionReference subcollection = userDocument.collection('userdata');

    // Step 2: Delete documents within the subcollection
    QuerySnapshot subcollectionSnapshot = await subcollection.get();
    subcollectionSnapshot.docs.forEach((DocumentSnapshot doc) async {
      await doc.reference.delete();
    });

    // Step 3: Delete the subcollection itself
    await subcollection.doc().delete();
  }
}

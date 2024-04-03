import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_compass/screens/authentication/login_screen.dart';
import 'package:coin_compass/screens/home/views/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _monthlyIncome_controller =
      TextEditingController();
  final TextEditingController _userName_controller = TextEditingController();

  bool isLoading = false;

  late User? _user;
  DocumentSnapshot? _userData;

  @override
  void initState() {
    super.initState();
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
              child: Icon(CupertinoIcons.back)),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: _user != null
            ? _userData != null
                ? SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              leading: GestureDetector(
                                onTap: () {},
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            "${_userData!['photoUrl']}",
                                          ),
                                          radius: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                "${_userData!['username']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 25),
                              ),
                              subtitle: Text(
                                "Income:${_userData!['monthlyIncome'].toString()} ₹",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return SingleChildScrollView(
                                                        child: AlertDialog(
                                                          title: Text(
                                                              "Edit User Name"),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Make sure to add username",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                TextFormField(
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  controller:
                                                                      _userName_controller,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  decoration: InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "User Name",
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12))),
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      kToolbarHeight,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await updateFirestoreData2(
                                                                          _userName_controller
                                                                              .text);
                                                                      _userName_controller
                                                                          .clear();
                                                                      usernameGradientSnackbar();
                                                                      Navigator.pushAndRemoveUntil(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  SettingsScreen()),
                                                                          (route) =>
                                                                              false);
                                                                    },
                                                                    child: Text(
                                                                      "Save",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                            },
                                            child: Center(
                                                child: Text(
                                              "Edit Name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            )),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                              child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return SingleChildScrollView(
                                                        child: AlertDialog(
                                                          title: Text(
                                                              "Edit Monthly Income"),
                                                          content: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  "Make sure to add income",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                TextFormField(
                                                                  keyboardType:TextInputType.number,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  controller:
                                                                      _monthlyIncome_controller,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  decoration: InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "Monthly Income",
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12))),
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      kToolbarHeight,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await updateFirestoreData(
                                                                          _monthlyIncome_controller
                                                                              .text);
                                                                      _monthlyIncome_controller
                                                                          .clear();
                                                                      incomeGradientSnackbar();
                                                                      Navigator.pushAndRemoveUntil(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  SettingsScreen()),
                                                                          (route) =>
                                                                              false);
                                                                    },
                                                                    child: Text(
                                                                      "Save",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              22,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  });
                                            },
                                            child: Text(
                                              "Edit Income",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          )),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ));
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                            Divider(
                              height: 30,
                              color: Colors.grey,
                            ),
                            ListTile(
                              onTap: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Logout"),
                                        content: Text(
                                            "Are you sure you want to logout?"),
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
                                                _signOut();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              },
                                              icon: Icon(
                                                Icons.done,
                                                color: Colors.green,
                                              ))
                                        ],
                                      );
                                    });
                              },
                              leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Color(0xFFFF2F08),
                                  size: 35,
                                ),
                              ),
                              title: Text(
                                ""
                                "Log Out",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: SpinKitThreeBounce(
                    color: Theme.of(context).colorScheme.primary,
                  ))
            : Center(
                child: Text('User not authenticated'),
              ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> saveDataToFirestore(String textData) async {
    // Convert textData to an integer
    int monthlyIncome = int.tryParse(textData) ?? 0;

    // Access Firestore and add data to the "users" collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'monthlyIncome': monthlyIncome,
      // Add other fields as needed
    });
  }

  Future<void> updateFirestoreData(String newValue) async {
    // Get the reference to the document you want to update
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the data
    await docRef.update({
      'monthlyIncome': int.tryParse(newValue) ?? 0,

      // Update other fields as needed
    });
  }

  Future<void> updateFirestoreData2(String newValue) async {
    // Get the reference to the document you want to update
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Update the data
    await docRef.update({
      'username': newValue,

      // Update other fields as needed
    });
  }

  void usernameGradientSnackbar() {
    Get.rawSnackbar(
      backgroundColor: Colors.transparent,
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      messageText: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            // Replace with your desired gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          'Username Edited Successfully',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void incomeGradientSnackbar() {
    Get.rawSnackbar(
      backgroundColor: Colors.transparent,
      borderRadius: 10.0,
      snackStyle: SnackStyle.FLOATING,
      messageText: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            // Replace with your desired gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          'Income Edited Successfully',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

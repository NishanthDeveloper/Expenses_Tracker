import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_compass/screens/home/views/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  String iconSelected = '';

  Color categoryColor = Colors.white;

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryIconController = TextEditingController();
  TextEditingController categoryColorController = TextEditingController();
  bool isExpended = false;
  List<String> myCategoriesIcons = [
    'food',
    'entertainment',
    'home',
    'shopping',
    'pet',
    'travel',
    'tech',
    'gym',
    'electricity',
    'recharge',
    'loan',
    'water'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add Expenses",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      keyboardType:TextInputType.number,
                      controller: expenseController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            FontAwesomeIcons.indianRupeeSign,
                            size: 16,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Expense field cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name field cannot be empty';
                      }
                      return null;
                    },
                    textAlignVertical: TextAlignVertical.center,
                    onTap: () {},
                    controller: categoryNameController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.clipboard,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12)))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: categoryIconController,
                    onTap: () {
                      setState(() {
                        isExpended = !isExpended;
                      });
                    },
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(
                        CupertinoIcons.chevron_down,
                        size: 12,
                        color: Colors.grey,
                      ),
                      hintText: "Icon",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: isExpended
                              ? BorderRadius.vertical(
                                  top: Radius.circular(12),
                                )
                              : BorderRadius.circular(12)),
                    ),
                  ),
                  isExpended
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: myCategoriesIcons.length,
                                itemBuilder: (context, int i) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        iconSelected = myCategoriesIcons[i];
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3,
                                            color: iconSelected ==
                                                    myCategoriesIcons[i]
                                                ? Colors.green
                                                : Colors.grey),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Lottie.asset(
                                          "assets/${myCategoriesIcons[i]}.json"),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: categoryColorController,

                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                      pickerColor: categoryColor,
                                      onColorChanged: (value) {
                                        setState(() {
                                          categoryColor = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.white),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true,
                    decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: categoryColor,
                        label: Text(
                          "Color",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        hintText: "Color",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: dateController,
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: selectDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      if (newDate != null) {
                        setState(() {
                          dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          selectDate = newDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          FontAwesomeIcons.clock,
                          size: 16,
                          color: Colors.grey,
                        ),
                        hintText: "Date",
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "(Make Sure to add Icon & Color)",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveDataToFirestore() {
    // Get the text from the controller and convert it to an integer
    String textValue = expenseController.text;
    int intValue = int.tryParse(textValue) ?? 0;

    // Reference to the Firestore collection (adjust 'your_collection' accordingly)
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userdata");

    // Add data to Firestore
    collectionReference.add({
      'categoryId': Uuid().v1(),
      'name': categoryNameController.text,
      'totalExpenses': intValue,
      'icon': iconSelected,
      'color': categoryColor.toString(),
      'date': dateController.text
    }).then((value) {
      print('Data added to Firestore');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }).catchError((error) {
      print('Error adding data to Firestore: $error');
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, save the data to Firestore

      saveDataToFirestore();
      showGradientSnackbar();
    }
  }

  void showGradientSnackbar() {
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
          'Expenses Added Successfully',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

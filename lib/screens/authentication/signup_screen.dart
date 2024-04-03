import 'package:coin_compass/components/page_title_bar.dart';
import 'package:coin_compass/components/under_part.dart';
import 'package:coin_compass/components/upside.dart';
import 'package:coin_compass/constants.dart';
import 'package:coin_compass/firebase_services/resources/auth_methods.dart';
import 'package:coin_compass/screens/authentication/login_screen.dart';
import 'package:coin_compass/screens/home/views/home_screen.dart';
import 'package:coin_compass/utils.dart';
import 'package:coin_compass/widget/rounded_button.dart';
import 'package:coin_compass/widget/rounded_input_field.dart';
import 'package:coin_compass/widget/rounded_password_field.dart';
import 'package:coin_compass/widget/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      monthlyIncome: 0,
      file: _image!,
    );
    if (res != "success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    super.initState();
  }

  late bool _passwordVisible;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/register.json",
                ),
                const PageTitleBar(title: 'Create New Account'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(_image!))
                                  : const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage("assets/user.png")),
                              Positioned(
                                  bottom: -10,
                                  left: 60,
                                  child: IconButton(
                                    onPressed: () {
                                      selectImage();
                                    },
                                    icon: const Icon(Icons.add_a_photo),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              TextFieldContainer(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'UserField Cannot be empty';
                                    }
                                    return null;
                                  },
                                  controller: _usernameController,
                                  cursorColor: kPrimaryColor,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      hintText: 'Name',
                                      hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans'),
                                      border: InputBorder.none),
                                ),
                              ),
                              TextFieldContainer(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'EmailField Cannot be empty';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  cursorColor: kPrimaryColor,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.email,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      hintText: 'Email',
                                      hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans'),
                                      border: InputBorder.none),
                                ),
                              ),
                              TextFieldContainer(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'PasswordField Cannot be empty';
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  obscureText: !_passwordVisible,
                                  cursorColor: kPrimaryColor,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(fontFamily: 'OpenSans'),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                child: _isLoading
                                    ? Center(
                                        child: SpinKitThreeBounce(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ))
                                    : RoundedButton(
                                        text: 'REGISTER',
                                        press: () {
                                          _checkImage();
                                          //_submitForm();
                                        }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Already have an account?",
                                navigatorText: "Login here",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, save the data to Firestore
      signUpUser();
    }
  }

  void _checkImage() {
    if (_image == null) {
      Get.rawSnackbar(
        backgroundColor: Colors.transparent,
        borderRadius: 10.0,
        snackStyle: SnackStyle.FLOATING,
        messageText: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'User Avatar Cannot be Empty',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      _submitForm();
    }
  }
}

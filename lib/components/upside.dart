import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Upside extends StatelessWidget {
  const Upside({Key? key, required this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: [
        Container(
          width: size.width,

          color: Colors.white,
          child: Lottie.asset(
            imgUrl,
            alignment: Alignment.topCenter,

          ),
        ),


      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class baseScreen extends StatefulWidget {
  baseScreen( {Key? key, required this.titleStr,required this.descStr, required this.isNext, required this.lottie}) : super(key: key);
  final String titleStr;
  final String descStr;
  final String lottie;
  bool isNext;
  @override
  State<baseScreen> createState() => _baseScreenState();
}

class _baseScreenState extends State<baseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffdadada),
      child: Padding(
        padding: EdgeInsets.only(left: 26, right: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container( // Image

              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Lottie.asset(widget.lottie, height: 10, width: 10),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "${widget.titleStr}",
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "${widget.descStr}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
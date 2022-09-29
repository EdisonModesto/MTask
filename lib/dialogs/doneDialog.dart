import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class doneDialog extends StatefulWidget {
  const doneDialog({Key? key}) : super(key: key);

  @override
  State<doneDialog> createState() => _doneDialogState();
}

class _doneDialogState extends State<doneDialog> with TickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xffDADADA),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            width: 300,
            height: 300,
            padding: EdgeInsets.all(50),
            child: Lottie.asset(
                "assets/lottie/done.json",
                width: 150,
                height: 150,
                controller: _controller,
                onLoaded: (composition){
                  _controller.duration = composition.duration;
                  _controller.forward().whenComplete(() => {
                    Navigator.pop(context),
                  });
                }
            )
        ),
      ),
    );
  }
}

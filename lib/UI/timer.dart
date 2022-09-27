import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class pomoTimer extends StatefulWidget {
  final setMin;

  const pomoTimer({@required this.setMin, Key? key}) : super(key: key);

  @override
  State<pomoTimer> createState() => _pomoTimerState();
}

class _pomoTimerState extends State<pomoTimer> {

  final CustomTimerController _controller = CustomTimerController();
  var remMin = 0.0;
  bool isWork = true;

  Duration durMin = Duration();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    durMin = Duration(minutes: widget.setMin);
    _controller.start(disableNotifyListeners: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTimer(
        controller: _controller,
        begin: durMin,
        end: Duration(),

        builder: (time) {
          remMin = ((60 * int.parse(time.minutes)) * 1000.0 )  +  (int.parse(time.seconds) * 1000) + int.parse(time.milliseconds);
          //remMin = ((((60 * int.parse(time.minutes).toDouble())*1000)+ int.parse(time.milliseconds).toDouble())*1000);
          print(durMin.inMilliseconds);
          return LiquidCircularProgressIndicator(
            value: remMin/((60.0 * widget.setMin)*1000), // Defaults to 0.5.
            valueColor: const AlwaysStoppedAnimation(Color(0xff0890BB)), // Defaults to the current Theme's accentColor.
            backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
            borderColor: const Color(0xff0890BB),
            borderWidth: 5.0,
            direction: Axis.vertical,
            center: Text(
                "${time.minutes}:${time.seconds}",
                style: TextStyle(fontSize: 18)
            ),// The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          );
        },

        stateBuilder: (time, state) {
          // This builder is shown when the state is different from "couting".
          if(state == CustomTimerState.counting) return Text(
              "The timer is paused",
              style: TextStyle(fontSize: 24.0)
          );

      // If null is returned, "builder" is displayed.
      return null;
    },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_machine/screens/cyberpunkfuture.dart';

class FutureInit extends StatefulWidget {
  @override
  _FutureInitState createState() => _FutureInitState();
}

class _FutureInitState extends State<FutureInit>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 3500);
  static String story;
  AnimationController controller;
  Animation<String> animation;
  List<String> options;

  @override
  void initState() {
    super.initState();
    story = "";
    options = ["", ""];
    controller = AnimationController(vsync: this, duration: _duration);
    animation = TypewriterTween(end: story).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void reset() {
    if (controller.status == AnimationStatus.completed) {
      controller.forward().whenComplete(() {
        setState(() {});
      });
    } else {
      controller.forward();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // reset();
    return Container(
        decoration: futureDecoration,
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Text('${animation.value}',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SpecialElite',
                              color: Colors.white));
                    },
                  ),
                ),
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                        color: Colors.transparent,
                        onPressed: () {
                          takeMeAhead(index);
                        },
                        child: Text(options[index],
                            style: GoogleFonts.merriweather(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal))),
                      ),
                    ),
                  );
                }),
          ],
        )));
  }

  void takeMeAhead(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/1.a');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/1.b');
    }
  }
}

class TypewriterTween extends Tween<String> {
  TypewriterTween({String begin = '', String end})
      : super(begin: begin, end: end);

  @override
  String lerp(double t) {
    var cutoff = (end.length * t).round();
    return end.substring(0, cutoff);
  }
}

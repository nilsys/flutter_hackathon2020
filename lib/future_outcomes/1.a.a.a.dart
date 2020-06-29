import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_machine/screens/cyberpunkfuture.dart';

class OneAAA extends StatefulWidget {
  @override
  _OneAAAState createState() => _OneAAAState();
}

class _OneAAAState extends State<OneAAA> with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(seconds: 8);
  static String story;
  AnimationController controller;
  Animation<String> animation;
  List<String> options;

  @override
  void initState() {
    super.initState();
    story =
        """You get in your car and floor it and chase after him. He maniacally drives through traffic, darting through signals, one way roads, parks and driving over sidewalks.
You tailgate him through all the carnage and eventually he loses control and crashes into an abandoned mall. He kicks his door open and stumbles out. You get out of your car and charge your magnum. As you approach him, you see a smile crawl over his face instead of fear. You get an ominous thought and your fears are confirmed as you hear the cocking of shotguns, rifles, handguns and plasma rifles all around you. You look at him one more time before everything disappears.
""";
    options = ["Continue"];
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

  Future<bool> getFlag() async {
    await Future.delayed(Duration(seconds: 8));
    return animation.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    // reset();
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Warning"),
                  content: Text(
                    "If you go back now, you'll lose your progress! :(",
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                        child: Text('Continue'),
                      ),
                    ),
                  ],
                ));
      },
      child: Container(
          decoration: futureDecoration,
          child: SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SpecialElite',
                                  color: Colors.white));
                        },
                      ),
                    ),
                  ),
                ),
                FutureBuilder<bool>(
                    future: getFlag(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 8.0, 30.0, 8.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)),
                                    color: Colors.transparent,
                                    onPressed: () {
                                      takeMeAhead(index);
                                    },
                                    child: Text(options[index],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.merriweather(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight:
                                                    FontWeight.normal))),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ))),
    );
  }

  void takeMeAhead(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/wakeup');
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

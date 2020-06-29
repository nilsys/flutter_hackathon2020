import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter95/flutter95.dart';
import 'package:time_machine/backend/apiprovider.dart';
import 'package:time_machine/backend/question.dart';
import 'package:time_machine/models/question_model.dart';
import 'package:parallax_image/parallax_image.dart';

//categories of the retro quizzes

class PastHome extends StatefulWidget {
  @override
  _PastHomeState createState() => _PastHomeState();
}

class _PastHomeState extends State<PastHome> {
  dynamic fontStyle = GoogleFonts.galada(textStyle: TextStyle(fontSize: 35.0));
  dynamic retroFont =
      GoogleFonts.ibmPlexMono(textStyle: TextStyle(fontSize: 20.0));
  int toolBar = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pushNamed(context, '/wormhole');
          Future.delayed(const Duration(seconds: 4), () {
            setState(() {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          });
        },
        child: Scaffold95(
            title: "The Past",
            toolbar: Toolbar95(actions: [
              Item95(
                label: 'Home',
                onTap: (context) {
                  setState(() {
                    toolBar = 0;
                  });
                },
              ),
              Item95(
                label: '',
              ),
              Item95(
                  label: 'Leaderboard',
                  onTap: (context) {
                    print("hi");
                    setState(() {
                      toolBar = 1;
                    });
                  }),
              Item95(
                label: '',
              ),
              Item95(
                label: 'Quizzes',
                menu: _buildMenu(context),
              ),
            ]),
            body: toolBar == 0 ? retroBody() : LeaderBoard()));
  }

  Widget retroBody() {
    int imgIndex;
    return Expanded(
      child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            print(index);
            imgIndex = index + 1;
            return Container(
              height: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img$imgIndex.jpg"),
                      fit: BoxFit.cover)),
            );
          }),
    );
  }

  Menu95 _buildMenu(BuildContext context) {
    return Menu95(
      items: [
        MenuItem95(
          value: 1,
          label: 'Tech',
        ),
        MenuItem95(
          value: 2,
          label: 'Cars',
        ),
      ],
      onItemSelected: (item) {
        if (item == 1) {
          Navigator.pushNamed(context, '/retrotech');
        } else if (item == 2) {
          Navigator.pushNamed(context, '/retrocars');
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

// skeletons

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  ApiProvider obj;

  @override
  void initState() {
    super.initState();
    obj = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: FutureBuilder(
            future: obj.getDataFromLeaderBoard(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              try {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Elevation95(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'USERNAME',
                                  style: Flutter95.textStyle,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'SCORE',
                                style: Flutter95.textStyle,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'CATEGORY',
                                style: Flutter95.textStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Elevation95(
                                  child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '${snapshot.data[index].userName}',
                                        style: Flutter95.textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '${snapshot.data[index].score}',
                                      style: Flutter95.textStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      snapshot.data[index].category == "Cars" ||
                                              snapshot.data[index].category ==
                                                  "Tech"
                                          ? '${snapshot.data[index].category}'
                                          : "",
                                      style: Flutter95.textStyle,
                                    ),
                                  ),
                                ],
                              ));
                            }),
                      ),
                    ],
                  );
                } else {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                }
              } catch (error) {
                return Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(""), fit: BoxFit.cover)));
              }
            }),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class RetroTech extends StatefulWidget {
  @override
  _RetroTechState createState() => _RetroTechState();
}

class _RetroTechState extends State<RetroTech> {
  ApiProvider obj;
  List<Question> questionList;

  @override
  void initState() {
    super.initState();
    questionList = [];
    obj = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: obj.getAllQuestions(1),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data.length);
          return QuizPage(snapshot.data, 1);
        } else {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class RetroCars extends StatefulWidget {
  @override
  _RetroCarsState createState() => _RetroCarsState();
}

class _RetroCarsState extends State<RetroCars> {
  ApiProvider obj;
  List<Question> questionList;

  @override
  void initState() {
    super.initState();
    questionList = [];
    obj = ApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: obj.getAllQuestions(2),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data.length);
          return QuizPage(snapshot.data, 2);
        } else {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

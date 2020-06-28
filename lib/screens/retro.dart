import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter95/flutter95.dart';
import 'package:time_machine/backend/apiprovider.dart';
import 'package:time_machine/backend/question.dart';
import 'package:time_machine/models/question_model.dart';

//categories of the retro quizzes
int toolBar = 1;

class PastHome extends StatefulWidget {
  @override
  _PastHomeState createState() => _PastHomeState();
}

class _PastHomeState extends State<PastHome> {
  dynamic fontStyle = GoogleFonts.galada(textStyle: TextStyle(fontSize: 35.0));
  dynamic retroFont =
      GoogleFonts.ibmPlexMono(textStyle: TextStyle(fontSize: 20.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
        title: "The Past",
        toolbar: Toolbar95(actions: [
          Item95(
            label: 'Leaderboard',
            onTap: (context) {
              setState(() {});
            },
          ),
          Item95(
            label: '',
          ),
          Item95(
            label: 'Quizzes',
            menu: _buildMenu(context),
          ),
          Item95(
            label: '',
          ),
          Item95(
            label: 'Facts',
            onTap: (context) {},
          ),
        ]),
        body: toolBar == 1 ? LeaderBoard() : retroBody());
  }
}

Widget retroBody() {
  return Container(
    child: Column(
      children: <Widget>[Text("hi")],
    ),
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
      toolBar = item;
      if (item == 1) {
        Navigator.pushNamed(context, '/retrotech');
      } else if (item == 2) {
        Navigator.pushNamed(context, '/retrocars');
      }
    },
  );
}

// skeletons

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
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
      child: Container(
        child: Expanded(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Elevation95(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Item $index',
                      style: Flutter95.textStyle,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
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
          return QuizPage(snapshot.data);
        } else {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
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
          return QuizPage(snapshot.data);
        } else {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
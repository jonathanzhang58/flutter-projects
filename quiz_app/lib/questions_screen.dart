import 'package:flutter/material.dart';
import 'package:quiz_app/answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});
  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  
  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex = currentQuestionIndex + 1;
    });
  }
  @override
  Widget build(context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  currentQuestion.text, 
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 241, 223, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ...currentQuestion.getShuffledAnswers().map((item){
                  return AnswerButton(item, (){
                    answerQuestion(item);
                  } );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/quiz.dart';
 
void main() {
  runApp(
   const Quiz()
  );
}



// import 'package:flutter/material.dart';

// void main() {
//   runApp(
//     MaterialApp(
//         home: Scaffold(
//       body: Container(
//         color: Colors.purple.shade900,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset('assets/images/quiz-logo.png', width: 200),
//               const SizedBox(height: 20),
//               const ElevatedButton(
//                 onPressed: null,
//                 child: Text(
//                   'Start Quiz',
//                   style: TextStyle(color: Colors.white, fontSize: 28),
//                 ),
//               ), // add onPressed
//             ],
//           ),
//         ),
//       ),
//     ),),
//   );
// }


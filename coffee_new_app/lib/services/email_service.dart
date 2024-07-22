import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> saveUserToFirestore(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'uid': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await saveUserToFirestore(user);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  
}

// import 'dart:math';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// class EmailService {
//   final String username = 'avigailgilboa967@gmail.com'; // שימו כאן את האימייל שלכם
//   final String password = 'TCHDHK4DKCUg'; // שימו כאן את הסיסמה שלכם

//   Future<void> sendEmail(String recipient, String subject, String text) async {
//     final smtpServer = gmail(username, password);
//     final message = Message()
//       ..from = Address(username, 'Your App Name')
//       ..recipients.add(recipient)
//       ..subject = subject
//       ..text = text;

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//     } on MailerException catch (e) {
//       print('Message not sent.');
//       for (var p in e.problems) {
//         print('Problem: ${p.code}: ${p.msg}');
//       }
//     }
//   }

//   String generateVerificationCode() {
//     final random = Random();
//     return List.generate(6, (_) => random.nextInt(10)).join();
//   }
// }


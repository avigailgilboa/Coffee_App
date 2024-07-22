
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:coffee_new_app/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isPhoneSelected = true;
  bool _isVerificationCodeSent = false;
  String? _verificationId;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("lib/images/latte.png", height: 150),
                    SizedBox(height: 50),
                    Text(
                      'היי, ברוכים הבאים',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'הזינו את מספר הטלפון או האימייל שלכם כדי להיכנס',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ToggleButtons(
                      borderColor: Colors.grey[300],
                      fillColor: Colors.brown[200],
                      borderWidth: 2,
                      selectedBorderColor: Colors.brown,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('טלפון'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('אימייל'),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isPhoneSelected = index == 0;
                        });
                      },
                      isSelected: [isPhoneSelected, !isPhoneSelected],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: isPhoneSelected ? _phoneController : _emailController,
                      keyboardType: isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: isPhoneSelected ? 'מספר טלפון' : 'אימייל',
                        prefixText: isPhoneSelected ? '+972' : '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'אנא הזינו ${isPhoneSelected ? 'מספר טלפון' : 'אימייל'}';
                        }
                        return null;
                      },
                    ),
                    if (_isVerificationCodeSent)
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'שלחנו לכם קוד אימות ל${_emailController.text.trim()}',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _verificationCodeController,
                            decoration: InputDecoration(
                              labelText: 'קוד אימות',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_verificationCodeController.text.isNotEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePage()),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'אישור',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    if (!_isVerificationCodeSent)
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });
                            if (isPhoneSelected) {
                              // טיפול באימות טלפון
                            } else {
                              await _sendVerificationCode(_emailController.text.trim());
                              setState(() {
                                _isVerificationCodeSent = true;
                                _isSubmitting = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            isPhoneSelected ? 'שלחו לי קוד אימות' : 'שלחו לי קוד אימות למייל',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode(String email) async {
    String code = _generateVerificationCode();
    await _firestore.collection('verification_codes').doc(email).set({
      'code': code,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await _sendEmail(email, 'Your Verification Code', 'Your verification code is $code');
  }

  Future<void> _sendEmail(String recipient, String subject, String text) async {
    final smtpServer = gmail('ohadleib@gmail.com', 'bcep gayq pxzx oxkf'); // השתמש באימייל ובסיסמה שלך
    final message = Message()
      ..from = Address('ohadleib@gmail.com', 'Coffee App')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  String _generateVerificationCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}


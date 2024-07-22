import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentPage extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  PaymentPage({required this.onPaymentSuccess});

  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber ='';
  String expiryDate ='';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (creditCartBrand){},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          // הצגת הודעת אישור לפני ניקוי העגלה
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Purchase'),
                              content: Text('Are you sure you want to complete the purchase?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // סגירת הדיאלוג
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.onPaymentSuccess();
                                    Navigator.pop(context); // סגירת הדיאלוג
                                    Navigator.pop(context); // חזרה לעמוד הקודם
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Payment Successful!'),
                                      ),
                                    );
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        }else{
                          print('invalid');
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Text('Validate',
                          style: TextStyle(color: Color.fromARGB(255, 128, 92, 39), fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel model){
    setState(() {
      cardNumber = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

}

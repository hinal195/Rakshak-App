import 'package:flutter/material.dart';
class CustomElevatedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  CustomElevatedButton({super.key,
    required this.title,
    required this.onPressed,
    this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:40,width:double.infinity,
      child:ElevatedButton(
        style:ButtonStyle(
          elevation:WidgetStateProperty.all(2),
          shadowColor:WidgetStateProperty.all(Colors.white),
          backgroundColor:WidgetStateProperty.all(Colors.pinkAccent.shade700),
          overlayColor: WidgetStateProperty.all(Colors.white24),

        ),
        child:Text(title,style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),onPressed: (){
        onPressed();
      },)
    );
  }
}

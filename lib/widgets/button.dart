import 'package:flutter/material.dart';



import '../ui/utils/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(10) ,
            color: primaryClr

        ),
        width:100 ,
        height: 50,
        child: Text(label,style: const TextStyle(color:Colors.white, ),
          textAlign:TextAlign.center ,
        ),
      ),
    );
  }
}

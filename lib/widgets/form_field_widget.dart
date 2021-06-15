import 'package:flutter/material.dart';
class FormFieldWidget extends StatelessWidget {
  String label;
  String hint;
  TextEditingController controller;
  bool isNumber;
  bool isDescription;
  FormFieldWidget({@required this.label,this.hint,this.controller,this.isNumber=false,this.isDescription=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,textAlign: TextAlign.left,style: TextStyle(color: Colors.black.withOpacity(.8),fontWeight: FontWeight.bold),),
        TextField(
          // minLines: 1,
          // maxLength: isDescription?3:1,
enableSuggestions: true,
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,

          ),
          keyboardType:isNumber? TextInputType.number:TextInputType.text,
        ),
        SizedBox(height: 25,),
      ],
    );
  }
}
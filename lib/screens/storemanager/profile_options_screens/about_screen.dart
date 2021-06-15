import 'package:flutter/material.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/widgets/main_button.dart';
class AboutScreen extends StatelessWidget {
  final _aboutTextStyle=TextStyle(fontSize: 15,fontWeight: FontWeight.w800,fontFamily: 'Montserrat',color: kGreyTextColor);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: .5,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),onPressed: (){
          Navigator.of(context).pop();
        },),
        centerTitle: true,
        title: Text("About",style: TextStyle(color: Colors.black),),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
SizedBox(height: 30,),
            Text("We are a company established in Mataró and committed to the growth of business and the economy of the city",style: _aboutTextStyle,),
            SizedBox(height: 20,),

            Text(" Our idea is to give a voice to small businesses in the new era and provide a service that could connect every bussiness to the new digital era and create more opportunities to increase local sales.",style: _aboutTextStyle),
            SizedBox(height: 20,),
Text("FEM Mataró is a tool designed by young enthusiasts to show selected products offers of Mataró based retail stores.",style: _aboutTextStyle),
            SizedBox(height: 20,),
            Text("Get to know us:",style: _aboutTextStyle),
        Text("www.femmataro.cat",style: _aboutTextStyle)







          ],
        ),
      ),
    );
  }
}

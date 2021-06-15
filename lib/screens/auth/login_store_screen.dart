import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/screens/choosing_plan_screen.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';
class LoginStoreScreen extends StatefulWidget {
  @override
  _LoginStoreScreenState createState() => _LoginStoreScreenState();
}

class _LoginStoreScreenState extends State<LoginStoreScreen> {
  bool _showPassword=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black87,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 70,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(child: Text("Login",style: kHeadingTextStype,)),
                Center(child: Text("Enter your email and Password",style: kSubHeadingTextStyle,)),
                SizedBox(height: 40,),
                FormFieldWidget(label: "Email",hint: "mataroni@labotiga.com",),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password",textAlign: TextAlign.left,style: TextStyle(color: Colors.black.withOpacity(.8),fontWeight: FontWeight.bold),),
                    TextField(
                      obscureText: _showPassword,
                      decoration: InputDecoration(
                        hintText: "* * * * * * *",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [TextButton(onPressed: (){}, child: Text("Forgot your password?"))],),
                    MainButton(title: "Log In",onPressed: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: ChoosingPlanScreen()));

                    },),
                    SizedBox(height: 20,),
                    Center(child: Text("Do you already have an account?",textAlign: TextAlign.center,)),
                    Center(
                      child: SizedBox(
                          height: 35,
                          width: 100,
                          child: TextButton(onPressed: (){}, child: Text("Log in"))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

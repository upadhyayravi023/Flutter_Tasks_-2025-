import 'package:flutter/material.dart';
import 'package:notes_app/utils/routes/routesName.dart';
import '../../view/signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/buttons.dart';
import '../res/colors.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
  class _LoginScreenState extends State<LoginScreen>{

   final TextEditingController _emailController =TextEditingController();
   final TextEditingController _passwordController =TextEditingController();
   final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
   final ValueNotifier<bool> _obscuretext = ValueNotifier<bool>(true);
final FocusNode _emailFocusNode =FocusNode();
final FocusNode _passwordFocusNode =FocusNode();

   @override
   void dispose() {
     super.dispose();
     _emailController.dispose();
     _passwordController.dispose();
     _emailFocusNode.dispose();
     _passwordFocusNode.dispose();
     _obscuretext.dispose();
     _loading.dispose();
   }

   @override
    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColors.grey),
              child: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_outlined,size: 24,color: Colors.black)),
              ),
            ),
          ),
        ),
        body:Padding(
          padding: const EdgeInsets.all(28.0),
          child: SafeArea(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome Back!",style: TextStyle(color: Colors.black,fontSize:48,fontWeight: FontWeight.w700),),
          SizedBox(height:32),
          TextFormField(
            style: TextStyle(color: Colors.black),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocusNode,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(24),
hintStyle: TextStyle(color: AppColors.darktext),
              hintText: "Email",
              prefixIcon: Icon(Icons.email,color: Colors.black),
              labelText: "Email",
              labelStyle: TextStyle(color: AppColors.darktext,fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppColors.mainColor),
              ),

filled : true,
              fillColor: AppColors.backgroundColor,
            ),
            onFieldSubmitted:(value){
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },

          ),
          SizedBox(height:24),
          ValueListenableBuilder(valueListenable: _obscuretext,
              builder: (context,value,child){
            return TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _passwordController,
              obscureText: _obscuretext.value,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(24),
                hintStyle: TextStyle(color: AppColors.darktext),
                hintText: "Password",
                prefixIcon: Icon(Icons.lock,color: Colors.black),
                labelStyle: TextStyle(color:AppColors.darktext,fontWeight: FontWeight.bold),
                labelText: "Password",
                suffixIcon: InkWell(onTap: (){
                  _obscuretext.value =!_obscuretext.value;
                },
                    child: _obscuretext.value? Icon(Icons.visibility_off_rounded,color: Colors.black):Icon(Icons.visibility_rounded,color: Colors.black)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.mainColor),
                ),
                filled : true,
                fillColor: AppColors.backgroundColor,

              ),
            );
              }),

SizedBox(height: 30,),
ValueListenableBuilder(
  valueListenable: _loading,
  builder: (context, value, child) {
    return Button(text: "Login",
    loading: value,
    onPressed: () async {
      if(_emailController.text.isEmpty){
        Utils.flushBarErrorMessage("Please enter email.",context);}
        else if(_passwordController.text.isEmpty){
          Utils.flushBarErrorMessage("Please enter password.", context);
      }
        else {
          _loading.value=true;
          try{
            final FirebaseAuth auth = FirebaseAuth.instance;
            await auth.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
            Navigator.pushNamed(context, RoutesName.entry);
    
          }on FirebaseAuthException catch(e){
            Utils.flushBarErrorMessage(e.message?? "An unknown error occurred", context);
          }finally{
            _loading.value=false;

          }
      }
    });
  }
),
SizedBox(height: 12,),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text("Don't have an account?",style: TextStyle(fontSize: 16,color: AppColors.darktext),),
                 TextButton(onPressed: (){
                   Navigator.pushNamed(context, RoutesName.signup);
                 },
                     child: Text("Sign Up",style: TextStyle(fontSize: 16,color: AppColors.darktext,fontWeight: FontWeight.bold)))
               ],
             ),
            ],
          ),
          ),
        )


      );
  }
}
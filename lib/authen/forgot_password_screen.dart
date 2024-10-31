import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: AppColors.backColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              Text(
                'Quên mật khẩu'.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 48.0,
                    color: Colors.white),
              ),
              SizedBox(height: 30),
              Image.asset(
                'images/forgot.png',
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Nhập email của bạn",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email của bạn';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: double.infinity,
                height: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: MaterialButton(onPressed: () {
                  
                }, color: AppColors.btnColor, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Gửi", style: TextStyle(fontSize: 20, color: Colors.white),),
                    SizedBox(width: 10),
                    Icon(Icons.send, color: Colors.white),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

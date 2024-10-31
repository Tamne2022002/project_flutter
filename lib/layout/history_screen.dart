import 'package:flutter/material.dart';
import 'package:project_flutter/color/Color.dart';
import 'package:project_flutter/layout/list_history_macth.dart';
import 'package:project_flutter/layout/list_history_practice.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.btnColor,
        title: Text(
          "Lịch sử".toUpperCase(),
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 76),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListHistoryExample()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Container(
                    width: double.maxFinite,
                    height: 64,
                    child: Center(
                        child: Text(
                      "Lịch sử luyện tập",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  )),
              SizedBox(
                height: 30,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListHistoryMatch()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Container(
                    width: double.maxFinite,
                    height: 64,
                    child: Center(
                        child: Text(
                      "Lịch sử thi đấu",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

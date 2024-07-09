import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
      home: test_bottom()));
}

class test_bottom extends StatefulWidget {
  const test_bottom({Key? key}) : super(key: key);

  @override
  State<test_bottom> createState() => _test_bottomState();
}

class _test_bottomState extends State<test_bottom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56.0,
          height: 56.0,

          decoration: BoxDecoration(

            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/logo_bottom.png"), // Replace with your image URL
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        height: 65,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 70),
                child: IconButton(
                  icon: const Icon(Icons.assignment,size: 30,),
                  onPressed: () {
                    setState(() {
                    });
                  },
                ),
              ),

              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,size: 30,),
                onPressed: () {
                  setState(() {
                  });
                },
              ),

            ],
          ),
        ),
      ),
      
    );
  }
}

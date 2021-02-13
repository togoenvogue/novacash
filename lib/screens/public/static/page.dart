import 'package:flutter/material.dart';
import '../../../styles/styles.dart';

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signup',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return null;
                  },
                  itemCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

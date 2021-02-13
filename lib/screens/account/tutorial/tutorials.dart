import 'package:flutter/material.dart';

import '../../../models/tutorial.dart';
import '../../../screens/account/tutorial/tutorial_list.dart';
import '../../../services/tutorial.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../styles/styles.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<TutorialModel> records = [];
  bool isLoading = false;

  void _getRecords() async {
    setState(() {
      isLoading = true;
    });
    var result = await TutorialService().tutorials();

    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
        isLoading = false;
      });
    } else {
      setState(() {
        records = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tutoriels',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 100,
                child: records.length > 0
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return TutorialList(
                            tutorial: records[index],
                          );
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message: 'Aucun tutoriel disponible pour le moment',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

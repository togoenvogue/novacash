import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../models/review.dart';
import '../../../screens/public/review/review_item.dart';
import '../../../services/review.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../screens/public/review/review_add.dart';
import '../../../screens/auth/login.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';

class ReviewScreen extends StatefulWidget {
  final String userKey;
  ReviewScreen({this.userKey});
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // redidrec to login
  void _redirectLogin() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: LoginScreen(),
        exitPage: LoginScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  bool isLoading = false;
  List<ReviewModel> records = [];

  void _getRecords() async {
    setState(() {
      isLoading = true;
    });
    var result = await ReviewService().reviews(page: 1);
    //print(result[0].error);
    setState(() {
      isLoading = false;
    });

    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
      });
    } else {
      setState(() {
        records = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commenter, Suggérer',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              if (widget.userKey != null) {
                Navigator.of(context).pushReplacement(
                  CubePageRoute(
                    enterPage: ReviewAddScreen(userKey: widget.userKey),
                    exitPage: ReviewAddScreen(userKey: widget.userKey),
                    duration: const Duration(milliseconds: 300),
                  ),
                );
              } else {
                // only logged users can post review
                CustomAlert(
                  colorBg: Colors.white,
                  colorText: Colors.black,
                ).confirm(
                  cancelFn: () {},
                  cancelText: 'Non',
                  confirmFn: _redirectLogin,
                  content: Text(
                    'Vous devez vous connecter pour poster un commenter. Voulez-vous vous connecter maintenant?',
                    textAlign: TextAlign.center,
                  ),
                  context: context,
                  submitText: 'Oui',
                  title: 'Accès sécurisé',
                );
              }
            },
            tooltip: 'Ajouter un commentaire',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-like.png',
                  fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 120,
                //width: double.infinity,
              ),
              SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height - 230,
                child: records.length > 0 && isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return ReviewListItem(
                            review: records[index],
                          );
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message: 'Soyez le premier à laisser un  commentaire',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';

import '../../../services/review.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../config/configuration.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../widgets/common/paragraphe.dart';
import '../../../styles/styles.dart';

class ReviewAddScreen extends StatefulWidget {
  final String userKey;
  ReviewAddScreen({this.userKey});

  @override
  _ReviewAddScreenState createState() => _ReviewAddScreenState();
}

class _ReviewAddScreenState extends State<ReviewAddScreen> {
  var _detail;
  double _rate;
  bool isLoading = false;

  void _setRating({double val}) {
    setState(() {
      _rate = val;
    });
  }

  void _submit() async {
    if (_detail != null && _detail.length >= 30 && _detail.length <= 300) {
      if (_rate != null && _rate > 0) {
        setState(() {
          isLoading = true;
        });
        CustomAlert()
            .loading(context: context, dismiss: false, isLoading: isLoading);

        var result = await ReviewService().reviewCreate(
            detail: _detail, rate: _rate.toInt(), userKey: widget.userKey);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        if (result.error == null) {
          // success
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
              context,
              'Merci!',
              'Votre message sera bientôt lu et modéré par un administrateur',
              false);
          // delay, redirect
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          // error
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(context, 'Oops!', result.error, true);
        }
      } else {
        //
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(context, 'Faites un effort',
            'Veuillez donner une note à $appName selon votre expérience', true);
      }
    } else {
      //
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(context, 'Attention!',
          'Votre message doit compter entre 30 et 300 caractères', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter un commentaire',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Paragraph(
                text:
                    '''Cet espace est réservé uniquement aux commentaires (vos avis) et suggestions pour améliorer $appName, pas pour l'assistance technique!
                    
Tous les commentaires sont lus, approuvés ou rejetés par notre équipe. Les injures, les insultes ainsi que les commentaires contenant des liens ne sont pas autorisés!''',
              ),
              CustomTextInput(
                labelText: 'Ecrivez votre message ici',
                isObscure: false,
                maxLines: 3,
                inputType: TextInputType.multiline,
                readOnly: false,
                borderRadius: 10,
                helpText: 'Entre 30 et 300 caractères! Ni plus, ni moins.',
                onChanged: (value) {
                  setState(() {
                    _detail = value;
                  });
                },
              ),
              CustomCard(
                content: Column(
                  children: [
                    Text('Donnez une note à $appName'),
                    SizedBox(height: 6),
                    RatingBar(
                      rating: 0,
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: Colors.grey,
                      ),
                      starCount: 5,
                      spacing: 5.0,
                      size: 40,
                      isIndicator: false,
                      allowHalfRating: false,
                      onRatingCallback:
                          (double value, ValueNotifier<bool> isIndicator) {
                        isIndicator.value = false;
                        _setRating(val: value);
                      },
                      color: Colors.amber,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomFlatButtonRounded(
                  label: 'Envoyer mon commenter',
                  borderRadius: 50,
                  function: () {
                    _submit();
                  },
                  bgColor: MyColors().primary,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import 'transaction/notify.dart';
import '../../../services/p2p.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../models/user.dart';
import '../../../styles/styles.dart';

class P2PSilverDashBoardScreen extends StatefulWidget {
  final UserModel userObj;
  P2PSilverDashBoardScreen({this.userObj});
  @override
  _P2PSilverDashBoardScreenState createState() =>
      _P2PSilverDashBoardScreenState();
}

class _P2PSilverDashBoardScreenState extends State<P2PSilverDashBoardScreen> {
  TextEditingController _sponsorController = TextEditingController();

  String _sponsorUsername;
  String _sponsorKey;
  bool isSponsorValid = false;
  bool isLoading = false;

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: isLoading,
    );

    var result = await P2PService().p2pSilverCreate(
      sponsorKey: _sponsorKey,
      userKey: widget.userObj.key,
    );
    Navigator.of(context).pop();

    if (result != null && result.error == null) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succès!',
        'Vous avez rejoint la matrice P2P SILVER avec succès. Redirection pour effectuer le paiement',
        false,
      );

      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
      // redirect to login
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: P2PTransactionNotifyScreen(don: result),
          exitPage: P2PTransactionNotifyScreen(don: result),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        result.error,
        true,
      );
    }
  }

  void _confirm() async {
    if (_sponsorUsername != null && isSponsorValid == false) {
      setState(() {
        isLoading = true;
      });
      CustomAlert()
          .loading(context: context, dismiss: false, isLoading: isLoading);
      var sponsor =
          await AuthService().getUserByUsername(username: _sponsorUsername);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      if (sponsor != null && sponsor.error == null) {
        if (sponsor.novaCashP2PSilver == true) {
          setState(() {
            isSponsorValid = true;
            _sponsorKey = sponsor.key;
          });
          // confirm
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).confirm(
            cancelFn: () {},
            cancelText: 'Annuler',
            confirmFn: _submit,
            content: Text(
              'Voulez-vous vraiment vous inscrire sous ${sponsor.firstName} ${sponsor.lastName} dans la matrice P2P SILVER?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            context: context,
            submitText: 'Oui',
            title: 'Confirmez',
          );
        } else {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Désolé!',
            '${sponsor.firstName} ${sponsor.lastName} n\'a pas encore activé la matrice P2P SILVER',
            true,
          );
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Oops!',
          sponsor.error,
          true,
        );
      }
    } else {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'P2P SILVER',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                'Suivez les instructions pour activer la matrice P2P SILVER',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              CustomTextInput(
                isObscure: false,
                maxLines: 1,
                //maxLength: 11,
                inputType: TextInputType.number,
                controller: _sponsorController,
                labelText:
                    'Entrez le ID (numéro de téléphone) de votre parrain pour continuer (Ex: 22676555543) *',
                helpText: 'Pas de parrain? Contactez-nous',
                onChanged: (sp) {
                  setState(() {
                    _sponsorUsername = sp;
                  });
                },
              ),
              CustomFlatButtonRounded(
                label: 'Valider',
                borderRadius: 50,
                function: () {
                  _confirm();
                },
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
